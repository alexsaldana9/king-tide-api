require 'test_utils'
include TestUtils

FactoryBot.define do

  factory :photo do
    sequence :category do |n|
      (n % 4) + 1
    end

    sequence :image do |n|
      test_image("test_image_#{(n % 2) + 1}.jpg")
    end
  end
end