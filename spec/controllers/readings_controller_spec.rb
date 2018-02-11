require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  render_views

  before do
    @r1 = create(:reading)
    @r2 = create(:reading)
  end

  describe 'get' do
    it 'returns the reading details' do
      get :get, params: {
          id: @r1.id
      }

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(@r1.to_json).excluding('deleted_at', 'photos')
    end

    it 'returns the reading details when it has photos' do
      ph1 = nil
      ph2 = nil

      expect {
        ph1 = create(:photo, reading: @r1)
        ph2 = create(:photo, reading: @r1)
      }.to change { Photo.count }.by(2)

      expected_result = %({
        "id": #{@r1.id},
        "depth": #{@r1.depth},
        "units_depth": "#{@r1.units_depth}",
        "salinity": #{@r1.salinity},
        "units_salinity": "#{@r1.units_salinity}",
        "description": "#{@r1.description || 'null'}",
        "approved": #{@r1.approved},
        "latitude": #{@r1.latitude || 'null'},
        "longitude": #{@r1.longitude || 'null'},
        "photos": [
          {"id": #{ph1.id}, "category": #{ph1.category}, "url": "#{ph1.image.url}"},
          {"id": #{ph2.id}, "category": #{ph2.category}, "url": "#{ph2.image.url}"}
        ]
      })

      get :get, params: {
          id: @r1.id
      }

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(expected_result).excluding('deleted_at')
    end

    it 'returns client error when reading id is invalid' do
      get :get, params: {
          id: 'invalid_reading'
      }

      expect(response.status).to eq(400)
    end

    it 'returns not found when reading id does not exist' do
      get :get, params: {
          id: -1
      }

      expect(response.status).to eq(404)
    end

    it 'returns not found when reading is deleted' do
      @r1.destroy

      get :get, params: {
        id: @r1.id
      }

      expect(response.status).to eq(404)
    end
  end

  describe 'all' do
    it 'reads all readings' do
      get :all

      expect(response.status).to eq(200)

      expect(response.body).to be_json_eql(Reading.all.to_json).excluding('deleted_at', 'photos')
    end

    it 'reads all readings excludes deleted readings' do
      @r1.destroy

      get :all

      expect(response.status).to eq(200)

      expect(Reading.count).to eq(Reading.with_deleted.count - 1)
      expect(response.body).to be_json_eql(Reading.all.to_json).excluding('deleted_at', 'photos')
    end
  end

  describe 'approved' do
    it 'reads approved readings' do
      @r1.approve!

      get :approved

      expect(response.status).to eq(200)
      expect(response.body).to be_json_eql([@r1].to_json).excluding('deleted_at', 'photos')
    end

    it 'approved readings do not show deleted' do
      @r1.approve!
      @r2.approve!
      @r2.destroy

      get :approved

      expect(response.status).to eq(200)
      expect(response.body).to be_json_eql([@r1].to_json).excluding('deleted_at', 'photos')
    end
  end

  describe 'pending' do
    it 'reads pending readings' do
      @r1.approve!

      get :pending

      expect(response.status).to eq(200)
      expect(response.body).to eq(Reading.pending.to_json)
      expect(response.body.to_json).not_to include {|r| r['id'] == @r1.id}
    end

    it 'pending readings do not show deleted' do
      @r2.destroy

      get :pending

      expect(response.status).to eq(200)
      expect(response.body).to eq(Reading.pending.to_json)
      expect(response.body.to_json).not_to include {|r| r['id'] == @r2.id}
    end
  end
end
