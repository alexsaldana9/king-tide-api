require 'rails_helper'

RSpec.describe 'Factory', type: :helper do
  describe :secret_key do
    it 'create different keys' do
      (1..100).each { create(:secret_key) }

      expect(SecretKey.pluck(:key).uniq.count).to eq(SecretKey.count)
    end
  end

  describe :reading do
    it 'creates different readings every time' do
      (1..100).each { create(:reading) }

      expect(Reading.pluck(:depth).uniq.count).to eq(Reading.count)
      expect(Reading.pluck(:units_depth).all? {|x| x == 'inches'}).to eq(true)

      expect(Reading.pluck(:salinity).uniq.count).to eq(Reading.count)
      expect(Reading.pluck(:units_salinity).all? {|x| x == 'ppt'}).to eq(true)

      expect(Reading.pluck(:description).uniq.count).to eq(Reading.count)
      expect(Reading.pluck(:approved).all? {|x| x == false}).to eq(true)
    end
  end
end