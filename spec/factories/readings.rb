# == Schema Information
#
# Table name: readings
#
#  id             :integer          not null, primary key
#  depth          :float
#  units_depth    :string
#  salinity       :integer
#  units_salinity :string
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  approved       :boolean
#  latitude       :float
#  longitude      :float
#  deleted_at     :datetime
#
# Indexes
#
#  index_readings_on_approved    (approved)
#  index_readings_on_deleted_at  (deleted_at)
#

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
