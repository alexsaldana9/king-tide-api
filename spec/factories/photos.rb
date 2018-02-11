# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  reading_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  category           :integer
#  deleted_at         :datetime
#
# Indexes
#
#  index_photos_on_deleted_at  (deleted_at)
#  index_photos_on_reading_id  (reading_id)
#
# Foreign Keys
#
#  fk_rails_...  (reading_id => readings.id)
#

FactoryBot.define do
  factory :photo do
    sequence :category do |n|
      (n % 4) + 1
    end

    sequence :image do |n|
      TestUtils.test_image("test_image_#{(n % 2) + 1}.jpg")
    end
  end
end
