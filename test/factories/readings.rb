FactoryBot.define do
  factory :reading do
    sequence :depth do |n|
      n + 1.5
    end

    units_depth 'inches'
    sequence :salinity do |n|
      n + 120
    end

    units_salinity 'ppt'
    sequence :description do |n|
      "description_#{n}"
    end
  end
end