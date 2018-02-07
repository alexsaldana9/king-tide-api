require 'test_helper'

class Secure::PhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @r1 = readings(:one)
  end

  test 'when key is not passed, photo is not created' do
    post '/photos', params: {
        reading_id: @r1.id,
        category: Photo::Category::DEPTH,
        image: test_image()
    }

    assert_response 401
    assert_equal true, Photo.all.empty?
  end

  test 'when key is invalid, photo not created' do
    post '/photos', params: {
        reading_id: @r1.id,
        category: Photo::Category::DEPTH,
        image: test_image()
    }, headers: {'apiKey' => 'invalidKEY'}

    assert_response 401
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when category is missing' do
    post '/photos', params: {
        reading_id: @r1.id,
        image: test_image()
    }, headers: {'apiKey' => 'keysample'}

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when category is invalid' do
    post '/photos', params: {
        reading_id: @r1.id,
        category: 'invalid',
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when category is out of range' do
    [-1, 0, 5, 6].each do |category|
      post '/photos', params: {
          reading_id: @r1.id,
          category: category,
          image: test_image()
      }, headers: {
          'apiKey' => 'keysample'
      }

      assert_response 400
      assert_equal true, Photo.all.empty?
    end
  end

  test 'does not create photo when reading_id is missing' do
    post '/photos', params: {
        category: Photo::Category::DEPTH,
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when reading_id is invalid' do
    post '/photos', params: {
        reading_id: 'invalid',
        category: Photo::Category::DEPTH,
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when reading_id is not in the db' do
    post '/photos', params: {
        reading_id: -1,
        category: Photo::Category::DEPTH,
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 404
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when image is missing' do
    post '/photos', params: {
        reading_id: @r1.id,
        category: Photo::Category::DEPTH
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'does not create photo when image parameter is not a valid image' do
    post '/photos', params: {
        reading_id: @r1.id,
        category: Photo::Category::DEPTH,
        image: test_image('not_a_photo.txt', 'text/plain')
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'uploads a photo' do
    seeded_filenames = %w(test_image_1.jpg test_image_2.jpg)
    seeded_filenames.each do |img|
      post '/photos', params: {
          reading_id: @r1.id,
          category: Photo::Category::DEPTH,
          image: test_image(img)
      }, headers: {
          'apiKey' => 'keysample'
      }

      assert_response 200
      assert_equal false, Photo.all.empty?
    end

    photo_urls = Reading.find(@r1.id)
                 .photos
                 .map(&:image)
                 .map(&:url)
    assert_equal seeded_filenames.count, photo_urls.count

    seeded_filenames.each do |f|
      assert photo_urls.any? {|u| u.include? f }
    end
  end

  test 'uploads a photo with a float category' do
    post '/photos', params: {
        reading_id: @r1.id,
        category: 1.5,
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 200
    assert_equal 1, Photo.count
    assert_equal 1, Photo.first.category
  end

  test 'cannot modify an approved reading' do
    @r1.approve!

    post '/photos', params: {
        reading_id: @r1.id,
        category: Photo::Category::DEPTH,
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal true, Photo.all.empty?
  end

  test 'cannot modify a deleted reading' do
    @r1.destroy

    post '/photos', params: {
        reading_id: @r1.id,
        category: Photo::Category::DEPTH,
        image: test_image()
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 404
    assert_equal true, Photo.all.empty?
  end

  private

  def test_image(filename='test_image_1.jpg', content_type='image/jpeg')
    return Rack::Test::UploadedFile.new("test/fixtures/files/#{filename}", content_type)
  end
end
