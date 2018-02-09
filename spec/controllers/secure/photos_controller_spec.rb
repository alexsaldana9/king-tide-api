require 'rails_helper'

RSpec.describe Secure::PhotosController, type: :request do
  before do
    @r1 = create(:reading)
    @key = create(:secret_key).key
  end

  describe 'create' do
    it 'when key is not passed, photo is not created' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }

        expect(response.status).to eq(401)
      }.not_to change { Photo.count }
    end

    it 'when key is invalid, photo not created' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }, headers: { 'apiKey' => 'invalidKEY' }

        expect(response.status).to eq(401)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when category is missing' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when category is invalid' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: 'invalid',
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when category is out of range' do
      expect {
        [-1, 0, 5, 6].each do |category|
          post '/photos', params: {
              reading_id: @r1.id,
              category: category,
              image: test_image()
          }, headers: { 'apiKey' => @key }

          expect(response.status).to eq(400)
        end
      }.not_to change { Photo.count }
    end

    it 'does not create photo when reading_id is missing' do
      expect {
        post '/photos', params: {
            category: Photo::Category::DEPTH,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when reading_id is invalid' do
      expect {
        post '/photos', params: {
            reading_id: 'invalid',
            category: Photo::Category::DEPTH,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when reading_id is not in the db' do
      expect {
        post '/photos', params: {
            reading_id: -1,
            category: Photo::Category::DEPTH,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(404)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when image is missing' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'does not create photo when image parameter is not a valid image' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image('not_a_photo.txt', 'text/plain')
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'uploads a photo' do
      seeded_filenames = %w(test_image_1.jpg test_image_2.jpg)

      expect {
        seeded_filenames.each do |img|
          post '/photos', params: {
              reading_id: @r1.id,
              category: Photo::Category::DEPTH,
              image: test_image(img)
          }, headers: { 'apiKey' => @key }

          expect(response.status).to eq(200)
        end
      }.to change { Photo.count }.by(seeded_filenames.count)

      photo_urls = @r1.reload.photos.map(&:image).map(&:url)
      expect(photo_urls.count).to eq(seeded_filenames.count)

      all_photos_created = seeded_filenames.all? do |f|
        photo_urls.any? {|u| u.include? f }
      end
      expect(all_photos_created).to eq(true)
    end

    it 'uploads a photo with a float category' do
      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: 3.5,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(200)
        expect(Photo.last.category).to eq(3)
      }.to change { Photo.count }.by(1)
    end

    it 'cannot modify an approved reading' do
      @r1.approve!

      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(400)
      }.not_to change { Photo.count }
    end

    it 'cannot modify a deleted reading' do
      @r1.destroy

      expect {
        post '/photos', params: {
            reading_id: @r1.id,
            category: Photo::Category::DEPTH,
            image: test_image()
        }, headers: { 'apiKey' => @key }

        expect(response.status).to eq(404)
      }.not_to change { Photo.count }
    end
  end

  private

  def test_image(filename='test_image_1.jpg', content_type='image/jpeg')
    return Rack::Test::UploadedFile.new("spec/fixtures/files/#{filename}", content_type)
  end
end