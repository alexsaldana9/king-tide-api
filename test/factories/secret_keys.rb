FactoryBot.define do
  factory :secret_key do
    name { "key_#{FactoryBot.random_string}" }
    key { "secret_#{FactoryBot.random_string}" }
  end
end