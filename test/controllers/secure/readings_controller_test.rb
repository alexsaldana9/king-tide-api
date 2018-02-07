require 'test_helper'

class Secure::ReadingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @r1 = readings(:one)
    @r2 = readings(:two)
  end

  test 'when key is not passed, record not approved' do
    post '/readings/approve', params: { id: @r1.id }

    assert_response 401
    assert_equal [false, false], Reading.all.map(&:approved)
  end

  test 'when key is invalid, record not approved' do
    post '/readings/approve', params: { id: @r1.id }, headers: {'apiKey' => 'invalidKEY'}

    assert_response 401
    assert_equal [false, false], Reading.all.map(&:approved)
  end

  test 'approve reading changes its approved status' do
    post '/readings/approve', params: { id: @r1.id }, headers: {'apiKey' => 'keysample'}

    assert_response 200
    assert_equal 2, Reading.count
    assert Reading.find(@r1.id).approved?
    assert_not Reading.find(@r2.id).approved?
  end

  test 'approve reading does not modify deleted records' do
    @r1.delete!

    post '/readings/approve', params: { id: @r1.id }, headers: {'apiKey' => 'keysample'}

    assert_response 404
    assert_equal [false, false], Reading.all.map(&:approved)
  end

  test 'approve Id that does not exists, returns 404' do
    post '/readings/approve', params: { id: -1 }, headers: {'apiKey' => 'keysample'}

    assert_response 404
    assert_equal [false, false], Reading.all.map(&:approved)
  end

  test 'creates reading with all parameters' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'FIU Nature Preserve - location- sample',
        latitude: 25.7548106,
        longitude: -80.3793627
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 200
    assert_equal 3, Reading.count

    created_reading = Reading.last
    assert_equal 3, created_reading.depth
    assert_equal 'feet', created_reading.units_depth
    assert_equal 30, created_reading.salinity
    assert_equal 'ppm', created_reading.units_salinity
    assert_equal 'FIU Nature Preserve - location- sample', created_reading.description
    assert_equal 25.7548106, created_reading.latitude
    assert_equal -80.3793627, created_reading.longitude
    assert_not created_reading.approved?
    assert_not created_reading.deleted?
  end

  test 'can create reading with no salinity' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 200
    assert_equal 3, Reading.count
  end

  test 'does not create reading when no apiKey is passed' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'inches',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }

    assert_response 401
    assert_equal 2, Reading.count
  end

  test 'does not create reading when apiKey is not valid' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'inches',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'wrongkey'
    }

    assert_response 401
    assert_equal 2, Reading.count
  end

  test 'missing depth param fails' do
    post '/readings/', params: {
        units_depth: 'inches',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid depth parameter fails' do
    post '/readings/', params: {
        depth: 'alex',
        units_depth: 'inches',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid units_depth parameter fails' do
    post '/readings/', params: {
        depth: 2.23,
        units_depth: "",
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'missing units_depth parameter fails' do
    post '/readings/', params: {
        depth: 2.23,
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid salinity will fail' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 'text',
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'Missing units_salinity parameter fails, when salinity parameter is passed' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 23,
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid latitude will fail' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: "foo",
        longitude: 160
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'missing latitude will fail' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        longitude: 160
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid latitude will fail, over positive side of range(-90 , 90) ex:140' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: 140,
        longitude: 160
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid latitude will fail, over negative side of range(-90 , 90) ex:-140' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: -140,
        longitude: 160
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'Missing latitude and longitude, reading will be saved' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description'
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 200
    assert_equal 3, Reading.count
  end

  test 'invalid longitude will fail' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: 45,
        longitude: "bar"
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'Missing longitude will fail' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: 45
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid longitude will fail, over positive side of range(-180 , 180) ex:200' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: 45,
        longitude: 200
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'invalid longitude will fail, over negative side of range(-180 , 180) ex:-200' do
    post '/readings/', params: {
        depth: 3,
        units_depth: 'feet',
        salinity: 30,
        units_salinity: 'ppm',
        description: 'sample description',
        latitude: 45,
        longitude: -200
    }, headers: {
        'apiKey' => 'keysample'
    }

    assert_response 400
    assert_equal 2, Reading.count
  end

  test 'delete r2' do
    delete '/readings/', params:{ id: @r2.id }, headers: { 'apiKey' => 'keysample'}

    assert_response 200
    assert_not Reading.find(@r1.id).deleted?
    assert Reading.find(@r2.id).deleted?
  end

  test 'does not delete, when apiKey is invalid' do
    delete '/readings/', params:{ id: @r2.id }, headers: { 'apiKey' => 'invalidKey'}

    assert_response 401
    assert_equal [false, false], Reading.all.map(&:deleted)
  end

  test 'does not delete, when apiKey is not passed' do
    delete '/readings/', params:{ id: @r2.id }

    assert_response 401
    assert_equal [false, false], Reading.all.map(&:deleted)
  end

  test 'id that does not exists, returns 404' do
    delete '/readings/', params: { id: -1 }, headers: { 'apiKey' => 'keysample'}

    assert_response 404
    assert_equal [false, false], Reading.all.map(&:deleted)
  end
end
