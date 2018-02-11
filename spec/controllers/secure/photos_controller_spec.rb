require 'rails_helper'

RSpec.describe Secure::PhotosController, type: :controller do
  before do
    @r1 = create(:reading)
    @key = create(:secret_key).key
  end

  describe 'create' do
    it 'when key is not passed, photo is not created' do
      expect {
        post :create, params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(401)
      }.not_to change { Photo.count }
    end

    it 'when key is invalid, photo not created' do
      expect {
        @request.headers['apiKey'] = 'invalidKEY'

        post :create, params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(401)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when category is missing' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            image: test_image()
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when category is invalid' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            category: 'invalid',
            image: test_image()
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when category is out of range' do
      expect {
        [-1, 0, 5, 6].each do |category|
          @request.headers['apiKey'] = @key

          post :create, params: {
              reading_id: @r1.id,
              category: category,
              image: test_image()
          }

          expect(response.status).to eq(400)
        end
      }.not_to change { Photo.count }
    end

    it 'does not create photo when reading_id is missing' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when reading_id is invalid' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: 'invalid',
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when reading_id is not in the db' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: -1,
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(404)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when image is missing' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when image parameter is not a valid image' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image('not_a_photo.txt', 'text/plain')
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'uploads a photo' do
      seeded_filenames = %w(test_image_1.jpg test_image_2.jpg)

      expect {
        seeded_filenames.each do |img|
          @request.headers['apiKey'] = @key

          post :create, params: {
              reading_id: @r1.id,
              category: Photo::Category::DEPTH,
              image: test_image(img)
          }

          expect(response.status).to eq(200)
        end

        expect(@r1.reload.photos.pluck(:image_file_name)).to eq(seeded_filenames)
      }.to change { Photo.count }.by(seeded_filenames.count)
    end

    it 'uploads a photo with a float category' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            category: 3.5,
            image: test_image()
        }

        expect(response.status).to eq(200)
        expect(Photo.last.category).to eq(3)
      }.to change { Photo.count }.by(1)
    end

    it 'cannot modify an approved reading' do
      @r1.approve!

      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'cannot modify a deleted reading' do
      @r1.destroy

      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(404)
      }.not_to change { Photo.count }
    end
  end
end
