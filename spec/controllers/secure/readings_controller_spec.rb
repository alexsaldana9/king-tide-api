require 'rails_helper'

RSpec.describe Secure::ReadingsController, type: :request do
  before do
    @r1 = create(:reading)
    @r2 = create(:reading)

    @key = create(:secret_key).key
    @reading_count_before_test = Reading.count
  end

  describe 'approve' do
    it 'when key is not passed, record not approved' do
      approved_before_test = Reading.with_deleted.pluck(:approved)

      post '/readings/approve', params: { id: @r1.id }

      expect(response.status).to eq(401)
      expect(Reading.pluck(:approved)).to eq(approved_before_test)
    end

    it 'when key is invalid, record not approved' do
      approved_before_test = Reading.with_deleted.pluck(:approved)

      post '/readings/approve', params: { id: @r1.id }, headers: {'apiKey' => 'invalidKEY'}

      expect(response.status).to eq(401)
      expect(Reading.pluck(:approved)).to eq(approved_before_test)
    end

    it 'approve reading changes its approved status' do
      post '/readings/approve', params: { id: @r1.id }, headers: {'apiKey' => @key}

      expect(response.status).to eq(200)
      expect(Reading.count).to eq(@reading_count_before_test)
      expect(Reading.find(@r1.id).approved?).to eq(true)
      expect(Reading.find(@r2.id).approved?).not_to eq(true)
    end

    it 'approve reading does not modify deleted records' do
      @r1.destroy
      approved_before_test = Reading.with_deleted.pluck(:approved)

      post '/readings/approve', params: { id: @r1.id }, headers: {'apiKey' => @key}

      expect(response.status).to eq(404)
      expect(Reading.with_deleted.pluck(:approved)).to eq(approved_before_test)
    end

    it 'approve Id that does not exists, returns 404' do
      approved_before_test = Reading.pluck(:approved)

      post '/readings/approve', params: { id: -1 }, headers: {'apiKey' => @key}

      expect(response.status).to eq(404)
      expect(Reading.pluck(:approved)).to eq(approved_before_test)
    end
  end

  describe 'create' do
    it 'creates reading with all parameters' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'FIU Nature Preserve - location- sample',
          latitude: 25.7548106,
          longitude: -80.3793627
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(200)
      expect(Reading.count).to eq(@reading_count_before_test + 1)

      created_reading = Reading.last
      expect(created_reading.depth).to eq(3)
      expect(created_reading.units_depth).to eq('feet')
      expect(created_reading.salinity).to eq(30)
      expect(created_reading.units_salinity).to eq('ppm')
      expect(created_reading.description).to eq('FIU Nature Preserve - location- sample')
      expect(created_reading.latitude).to eq(25.7548106)
      expect(created_reading.longitude).to eq(-80.3793627)
      expect(created_reading.approved?).not_to eq(true)
      expect(created_reading.deleted?).not_to eq(true)
    end

    it 'can create reading with no salinity' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(200)
      expect(Reading.count).to eq(@reading_count_before_test + 1)
    end

    it 'does not create reading when no apiKey is passed' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'inches',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }

      expect(response.status).to eq(401)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'does not create reading when apiKey is not valid' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'inches',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => 'wrongkey'
      }

      expect(response.status).to eq(401)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'missing depth param fails' do
      post '/readings/', params: {
          units_depth: 'inches',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid depth parameter fails' do
      post '/readings/', params: {
          depth: 'alex',
          units_depth: 'inches',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid units_depth parameter fails' do
      post '/readings/', params: {
          depth: 2.23,
          units_depth: "",
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'missing units_depth parameter fails' do
      post '/readings/', params: {
          depth: 2.23,
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid salinity will fail' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 'text',
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'Missing units_salinity parameter fails, when salinity parameter is passed' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 23,
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid latitude will fail' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: "foo",
          longitude: 160
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'missing latitude will fail' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          longitude: 160
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid latitude will fail, over positive side of range(-90 , 90) ex:140' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: 140,
          longitude: 160
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid latitude will fail, over negative side of range(-90 , 90) ex:-140' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: -140,
          longitude: 160
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'Missing latitude and longitude, reading will be saved' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description'
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(200)
      expect(Reading.count).to eq(@reading_count_before_test + 1)
    end

    it 'invalid longitude will fail' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: 45,
          longitude: "bar"
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'Missing longitude will fail' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: 45
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid longitude will fail, over positive side of range(-180 , 180) ex:200' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: 45,
          longitude: 200
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end

    it 'invalid longitude will fail, over negative side of range(-180 , 180) ex:-200' do
      post '/readings/', params: {
          depth: 3,
          units_depth: 'feet',
          salinity: 30,
          units_salinity: 'ppm',
          description: 'sample description',
          latitude: 45,
          longitude: -200
      }, headers: {
          'apiKey' => @key
      }

      expect(response.status).to eq(400)
      expect(Reading.count).to eq(@reading_count_before_test)
    end
  end

  describe 'delete' do
    it 'delete r2' do
      delete '/readings/', params:{ id: @r2.id }, headers: { 'apiKey' => @key }

      expect(response.status).to eq(200)
      expect(Reading.with_deleted.find(@r1.id).deleted?).not_to eq(true)
      expect(Reading.with_deleted.find(@r2.id).deleted?).to eq(true)
    end

    it 'does not delete when apiKey is invalid' do
      deleted_before_test = Reading.with_deleted.map(&:deleted?)

      delete '/readings/', params:{ id: @r2.id }, headers: { 'apiKey' => 'invalidKey' }

      expect(response.status).to eq(401)
      expect(Reading.with_deleted.map(&:deleted?)).to eq(deleted_before_test)
    end

    it 'does not delete when apiKey is not passed' do
      deleted_before_test = Reading.with_deleted.map(&:deleted?)

      delete '/readings/', params:{ id: @r2.id }

      expect(response.status).to eq(401)
      expect(Reading.with_deleted.map(&:deleted?)).to eq(deleted_before_test)
    end

    it 'delete id that does not exists returns 404' do
      deleted_before_test = Reading.with_deleted.map(&:deleted?)

      delete '/readings/', params: { id: -1 }, headers: { 'apiKey' => @key }

      expect(response.status).to eq(404)
      expect(Reading.with_deleted.map(&:deleted?)).to eq(deleted_before_test)
    end
  end
end
