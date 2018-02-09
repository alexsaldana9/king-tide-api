require 'rails_helper'

RSpec.describe Secure::ReadingsController, type: :controller do
  before do
    @r1 = create(:reading)
    @r2 = create(:reading)

    @key = create(:secret_key).key
  end

  describe 'approve' do
    it 'when key is not passed, record not approved' do
      expect {
        post :approve, params: { id: @r1.id }

        expect(response.status).to eq(401)
      }.not_to change { Reading.with_deleted.pluck(:approved) }
    end

    it 'when key is invalid, record not approved' do
      expect {
        @request.headers['apiKey'] = 'invalidKEY'

        post :approve, params: { id: @r1.id }

        expect(response.status).to eq(401)
      }.not_to change { Reading.with_deleted.pluck(:approved) }
    end

    it 'approve reading changes its approved status' do
      expect {
        @request.headers['apiKey'] = @key

        post :approve, params: { id: @r1.id }

        expect(response.status).to eq(200)
      }.to change { Reading.count }.by(0)
               .and change { Reading.approved.count }.by(1)
                        .and change { @r1.reload.approved? }.to(true)
    end

    it 'approve reading does not modify deleted records' do
      @r1.destroy

      expect {
        @request.headers['apiKey'] = @key

        post :approve, params: { id: @r1.id }

        expect(response.status).to eq(404)
      }.not_to change { Reading.with_deleted.pluck(:approved) }
    end

    it 'approve Id that does not exists, returns 404' do
      expect {
        @request.headers['apiKey'] = @key

        post :approve, params: { id: -1 }

        expect(response.status).to eq(404)
      }.not_to change { Reading.with_deleted.pluck(:approved) }
    end
  end

  describe 'create' do
    it 'creates reading with all parameters' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'FIU Nature Preserve - location- sample',
            latitude: 25.7548106,
            longitude: -80.3793627
        }

        expect(response.status).to eq(200)
      }.to change { Reading.count }.by(1)

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
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            description: 'sample description'
        }

        expect(response.status).to eq(200)
      }.to change { Reading.count }.by(1)
    end

    it 'does not create reading when no apiKey is passed' do
      expect {
        post :create, params: {
            depth: 3,
            units_depth: 'inches',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(401)
      }.not_to change { Reading.count }
    end

    it 'does not create reading when apiKey is not valid' do
      expect {
        @request.headers['apiKey'] = 'wrongkey'

        post :create, params: {
            depth: 3,
            units_depth: 'inches',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(401)
      }.not_to change { Reading.count }
    end

    it 'missing depth param fails' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            units_depth: 'inches',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid depth parameter fails' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 'alex',
            units_depth: 'inches',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid units_depth parameter fails' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 2.23,
            units_depth: "",
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'missing units_depth parameter fails' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 2.23,
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid salinity will fail' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 'text',
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'Missing units_salinity parameter fails, when salinity parameter is passed' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 23,
            description: 'sample description'
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid latitude will fail' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: "foo",
            longitude: 160
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'missing latitude will fail' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            longitude: 160
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid latitude will fail, over positive side of range(-90 , 90) ex:140' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: 140,
            longitude: 160
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid latitude will fail, over negative side of range(-90 , 90) ex:-140' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: -140,
            longitude: 160
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'Missing latitude and longitude, reading will be saved' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description'
        }

        expect(response.status).to eq(200)
      }.to change { Reading.count }.by(1)
    end

    it 'invalid longitude will fail' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: 45,
            longitude: "bar"
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'Missing longitude will fail' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: 45
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid longitude will fail, over positive side of range(-180 , 180) ex:200' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: 45,
            longitude: 200
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end

    it 'invalid longitude will fail, over negative side of range(-180 , 180) ex:-200' do
      expect {
        @request.headers['apiKey'] = @key

        post :create, params: {
            depth: 3,
            units_depth: 'feet',
            salinity: 30,
            units_salinity: 'ppm',
            description: 'sample description',
            latitude: 45,
            longitude: -200
        }

        expect(response.status).to eq(400)
      }.not_to change { Reading.count }
    end
  end

  describe 'delete' do
    it 'delete r2' do
      expect {
        @request.headers['apiKey'] = @key

        delete :delete, params: {
            id: @r2.id
        }

        expect(response.status).to eq(200)
      }.to change { Reading.with_deleted.count(&:deleted?) }.by(1)
               .and change { @r2.reload.deleted? }.to(true)
    end

    it 'does not delete when apiKey is invalid' do
      expect {
        @request.headers['apiKey'] = 'invalidKey'

        delete :delete, params: {
            id: @r2.id
        }

        expect(response.status).to eq(401)
      }.not_to change { Reading.with_deleted.map(&:deleted?) }
    end

    it 'does not delete when apiKey is not passed' do
      expect {
        delete :delete, params:{
            id: @r2.id
        }

        expect(response.status).to eq(401)
      }.not_to change { Reading.with_deleted.map(&:deleted?) }
    end

    it 'delete id that does not exists returns 404' do
      expect {
        @request.headers['apiKey'] = @key

        delete :delete, params: {
            id: -1
        }

        expect(response.status).to eq(404)
      }.not_to change { Reading.with_deleted.map(&:deleted?) }
    end
  end
end
