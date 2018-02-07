require 'test_helper'

class Secure::PhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @r1 = readings(:one)
  end

  test 'when key is not passed, photo is not created' do
    post '/photos', params: { reading_id: @r1.id }

    assert_response 401
    assert_equal 0, Photo.count
  end

  test 'when key is invalid, photo not created' do
    post '/photos', params: { reading_id: @r1.id }, headers: {'apiKey' => 'invalidKEY'}

    assert_response 401
    assert_equal 0, Photo.count
  end

end
