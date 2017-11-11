# spec/controllers/readings_controller_spec.rb

require "spec_helper"
# require 'jwt'

describe ReadingsController , :type => :api do

  context 'Get all readings'
  before do
    # header "Authorization", "apiKey #{llave2}"
    r1 = Reading.create(depth: 2.0, units_depth: 'inches', salinity: 100, units_salinity: 'ppt', description: 'Flood at Vizcaya' )
    @r2 = Reading.create(depth: 4.0, units_depth: 'inches', salinity: 50, units_salinity: 'ppt', description: 'Flood at Brickell' )
    key = Secretkey.create(name: 'sample', key: 'keysample')
  end

  it 'responds with a all readings' do
    get "readings/all"

    expect(last_response.status).to eq(200)

    readings = Reading.all.each.to_json
    expect(json.each.to_json).to eq(readings)
  end

  describe 'Create reading' do
    it 'Create reading' do
      header 'apiKey', 'keysample'
      post "readings/", { depth: 3, units_depth: 'feet', salinity: 30, units_salinity: 'ppm', description: 'sample description' }

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
  end

  describe 'Update reading' do
    xit 'Update r2' do
      header 'apiKey', 'keysample'
      r2 = { depth: 3, units_depth: 'feet', salinity: 30, units_salinity: 'ppm', description: 'Update sample' }
      put "readings/", r2

      expect(last_response.status).to eq(200)
      expect(Reading.count).to eq(2)

    end
  end

  describe 'Delete reading' do
    it 'Delete r2' do
      header 'apiKey', 'keysample'
      delete "readings/", { id: @r2.id }

      expect(last_response.status).to eq(200)
      expect(Reading.count).to eq(1)
    end

  end

end