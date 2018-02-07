require 'test_helper'

class ReadingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @r1 = readings(:one)
    @r2 = readings(:two)
  end

  test 'returns the reading details' do
    get "/readings/#{@r1.id}", as: :json

    assert_response 200

    assert_equal @r1.to_json, response.body
  end

  test 'returns client error when reading id is invalid' do
    get '/readings/invalid_reading', as: :json

    assert_response 400
  end

  test 'returns not found when reading id does not exist' do
    get '/readings/-1', as: :json

    assert_response 404
  end

  test 'returns not found when reading is deleted' do
    @r1.delete!

    get "/readings/#{@r1.id}", as: :json

    assert_response 404
  end

  test 'reads all readings' do
    get '/readings/all', as: :json

    assert_response 200

    readings = Reading.all.each.to_json
    assert_equal readings, response.body
  end

  test 'reads approved readings' do
    @r1.approve!

    get '/readings/approved', as: :json

    assert_response 200
    assert_equal JSON.parse([@r1].each.to_json), JSON.parse(response.body)
  end

  test 'approved readings do not show deleted' do
    @r1.approve!
    @r2.approve!
    @r2.delete!

    get '/readings/approved'

    assert_response 200
    assert_equal JSON.parse([@r1].each.to_json), JSON.parse(response.body)
  end

  test 'reads pending readings' do
    @r1.approve!

    get '/readings/pending'

    assert_response 200
    assert_equal JSON.parse([@r2].each.to_json), JSON.parse(response.body)
  end

  test 'pending readings do not show deleted' do
    @r2.delete!

    get '/readings/pending'

    assert_response 200
    assert_equal JSON.parse([@r1].each.to_json), JSON.parse(response.body)
  end
end
