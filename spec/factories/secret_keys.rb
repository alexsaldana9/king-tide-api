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