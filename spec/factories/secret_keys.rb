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

FactoryBot.define do
  factory :secret_key do
    sequence :name do |n|
      "name_#{n}"
    end

    sequence :key do |n|
      "key_#{n}"
    end
  end
end
