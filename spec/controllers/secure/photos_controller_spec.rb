require 'rails_helper'

RSpec.describe Secure::PhotosController, type: :request do
  before do
    @r1 = create(:reading)
    @key = create(:secret_key).key
  end

  describe 'create' do
    it 'when key is not passed, photo is not created' do
      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH,
          image: test_image()
      }

      expect(response.status).to eq(401)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'when key is invalid, photo not created' do
      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH,
          image: test_image()
      }, headers: {
          'apiKey' => 'invalidKEY'
      }

      expect(response.status).to eq(401)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when category is missing' do
      post '/photos', params: {
          reading_id: @r1.id,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when category is invalid' do
      post '/photos', params: {
          reading_id: @r1.id,
          category: 'invalid',
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when category is out of range' do
      [-1, 0, 5, 6].each do |category|
        post '/photos', params: {
            reading_id: @r1.id,
            category: category,
            image: test_image()
        }, headers: {
            'apiKey' => @key
        }

        expect(response.status).to eq(400)
        expect(Photo.all.empty?).to eq(true)
      end
    end

    it 'does not create photo when reading_id is missing' do
      post '/photos', params: {
          category: Photo::Category::DEPTH,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when reading_id is invalid' do
      post '/photos', params: {
          reading_id: 'invalid',
          category: Photo::Category::DEPTH,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when reading_id is not in the db' do
      post '/photos', params: {
          reading_id: -1,
          category: Photo::Category::DEPTH,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(404)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when image is missing' do
      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'does not create photo when image parameter is not a valid image' do
      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH,
          image: test_image('not_a_photo.txt', 'text/plain')
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'uploads a photo' do
      seeded_filenames = %w(test_image_1.jpg test_image_2.jpg)
      seeded_filenames.each do |img|
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image(img)
        }, headers: {
            'apiKey' => @key
        }

        expect(response.status).to eq(200)
        expect(Photo.all.empty?).not_to eq(true)
      end

      photo_urls = Reading.find(@r1.id)
                       .photos
                       .map(&:image)
                       .map(&:url)
      assert_equal seeded_filenames.count, photo_urls.count

      seeded_filenames.each do |f|
        expect(photo_urls.any? {|u| u.include? f }).to eq(true)
      end
    end

    it 'uploads a photo with a float category' do
      post '/photos', params: {
          reading_id: @r1.id,
          category: 1.5,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(200)
      expect(Photo.count).to eq(1)
      expect(Photo.first.category).to eq(1)
    end

    it 'cannot modify an approved reading' do
      @r1.approve!

      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Photo.all.empty?).to eq(true)
    end

    it 'cannot modify a deleted reading' do
      @r1.destroy

      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH,
          image: test_image()
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(404)
      expect(Photo.all.empty?).to eq(true)
    end
  end

  private

  def test_image(filename='test_image_1.jpg', content_type='image/jpeg')
    return Rack::Test::UploadedFile.new("spec/fixtures/files/#{filename}", content_type)
  end
end
