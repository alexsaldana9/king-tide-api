# == Schema Information
#
# Table name: secret_keys
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#  key        :string
#

require 'rails_helper'

RSpec.describe SecretKey, type: :model do
  before do
    @keys = (1...3).map { create(:secret_key).key }
  end

  describe :is_valid do
    it 'returns false for empty parameters' do
      expect(SecretKey.is_valid(nil)).to eq(false)
      expect(SecretKey.is_valid('')).to eq(false)
    end

    it 'returns false for invalid keys' do
      expect(SecretKey.is_valid('incorrect')).to eq(false)
      expect(SecretKey.is_valid('invalid')).to eq(false)
    end

    it 'returns true for valid keys' do
      @keys.each do |k|
        expect(SecretKey.is_valid(k)).to eq(true)
      end
    end
  end
end
