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

  describe :photo do
    before do
      @r1 = create(:reading)
      @r2 = create(:reading)
    end

    it 'associates the photos with the reading' do
      (1..2).each { create(:photo, reading: @r1) }
      (1..2).each { create(:photo, reading: @r2) }

      expect(@r1.photos.count).to eq(2)
      expect(@r2.photos.count).to eq(2)

      expect(@r1.photos.map(&:image).map(&:url).uniq.count).to eq(2)
      expect(@r2.photos.map(&:image).map(&:url).uniq.count).to eq(2)

      expect((@r1.photos.map(&:category) + @r2.photos.map(&:category)).uniq.count).to eq(4)
    end
  end
end