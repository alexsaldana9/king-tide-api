# spec/controllers/readings_controller_spec.rb

require "spec_helper"
# require 'jwt'

describe ReadingsController , :type => :api do

  context 'Get all readings'
  before do
    # header "Authorization", "apiKey #{llave2}"
    r1 = Reading.create(depth: 2.0, units_depth: 'inches', salinity: 100, units_salinity: 'ppt', description: 'Flood at Vizcaya' )
    r2 = Reading.create(depth: 4.0, units_depth: 'inches', salinity: 50, units_salinity: 'ppt', description: 'Flood at Brickell' )

  end

  it 'responds with a all readings' do
    get "readings/all"

    expect(last_response.status).to eq(200)

    readings = Reading.all.each.to_json
    expect(json.each.to_json).to eq(readings)
  end
end
