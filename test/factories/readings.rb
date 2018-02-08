FactoryBot.define do
  factory :reading do
    depth { FactoryBot.random_float(1.0, 9.9) }
    units_depth 'inches'
    salinity { FactoryBot.random_int(20, 800) }
    units_salinity 'ppt'
    description { "description_#{FactoryBot.random_string}" }
  end
end