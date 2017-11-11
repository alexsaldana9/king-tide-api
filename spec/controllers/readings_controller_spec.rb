# spec/controllers/readings_controller_spec.rb

require "spec_helper"
# require 'jwt'

describe ReadingsController , :type => :api do

  context 'Get all readings'
  before do
    # header "Authorization", "apiKey #{llave2}"
    r1 = Reading.create(depth: 2.0, units_depth: 'inches', salinity: 100, units_salinity: 'ppt', description: 'Flood at Vizcaya', approved: false, deleted: false)
    @r2 = Reading.create(depth: 4.0, units_depth: 'inches', salinity: 50, units_salinity: 'ppt', description: 'Flood at Brickell', approved: false, deleted: false)
    key = Secretkey.create(name: 'sample', key: 'keysample')
  end

  it 'responds with a all readings' do
    get "readings/all"

    expect(last_response.status).to eq(200)

    readings = Reading.all.each.to_json
    expect(json.each.to_json).to eq(readings)
  end

  describe 'Create reading' do
    it 'Create reading with all parameters' do
      header 'apiKey', 'keysample'
      post "readings/", { depth: 3, units_depth: 'feet', salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(200)
      expect(Reading.count).to eq(3)

      created_reading = Reading.last
      expect(created_reading.depth).to eq(3)
      expect(created_reading.units_depth).to eq('feet')
      expect(created_reading.salinity).to eq(30)
      expect(created_reading.units_salinity).to eq('ppm')
      expect(created_reading.description).to eq('sample description')
      expect(created_reading.approved).to eq(false)
      expect(created_reading.deleted).to eq(false)

    end

    it 'Can create reading with no salinity' do
      header 'apiKey', 'keysample'
      post "readings/", { depth: 3, units_depth: 'feet', description: 'sample description' }

      expect(last_response.status).to eq(200)
      expect(Reading.count).to eq(3)
    end

    it 'Does not create reading when no apiKey is passed' do
      post "readings/", { depth: 3, units_depth: 'inches', salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(401)
      expect(Reading.count).to eq(2)
    end

    it 'Does not create reading when apiKey is not valid' do
      header 'apiKey', 'wrongkey'
      post "readings/", { depth: 3, units_depth: 'inches', salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(401)
      expect(Reading.count).to eq(2)
    end

    it 'Missing depth param fails' do
      header 'apiKey', 'keysample'
      post "readings/", { units_depth: 'inches', salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end

    it 'Invalid depth parameter fails' do
      header 'apiKey', 'keysample'
      post "readings/", {depth: "alex", units_depth: 'inches', salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end

    it 'Invalid units_depth parameter fails' do
      header 'apiKey', 'keysample'
      post "readings/", {depth: 2.23, units_depth: "", salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end

    it 'Missing units_depth parameter fails' do
      header 'apiKey', 'keysample'
      post "readings/", {depth: 2.23, salinity: 30, units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end

    it 'Invalid salinity will fail' do
      header 'apiKey', 'keysample'
      post "readings/", { depth: 3, units_depth: 'feet', salinity: 'text', units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end

    it 'Invalid salinity will fail' do
      header 'apiKey', 'keysample'
      post "readings/", { depth: 3, units_depth: 'feet', salinity: 'text', units_salinity: 'ppm', description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end

    it 'Missing units_salinity parameter fails, when salinity parameter is passed' do
      header 'apiKey', 'keysample'
      post "readings/", { depth: 3, units_depth: 'feet', salinity: 23, description: 'sample description' }

      expect(last_response.status).to eq(400)
      expect(Reading.count).to eq(2)
    end
  end


  describe 'Delete reading' do
    it 'Delete r2' do
      header 'apiKey', 'keysample'
      delete "readings/", { id: @r2.id }

      expect(last_response.status).to eq(200)
      expect(Reading.all.map(&:deleted)).to eq([false, true])
    end

    it 'Does not delete, when apiKey is invalid' do
      header 'apiKey', 'invalidKey'
      delete "readings/", { id: @r2.id }

      expect(last_response.status).to eq(401)
      expect(Reading.all.map(&:deleted)).to eq([false, false])
    end

    it 'Does not delete, when apiKey is not passed' do
      delete "readings/", { id: @r2.id }

      expect(last_response.status).to eq(401)
      expect(Reading.all.map(&:deleted)).to eq([false, false])
    end

  end

end
