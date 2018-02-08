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

class Photo < ApplicationRecord
  acts_as_paranoid

  belongs_to :reading

  class Category
    DEPTH=1
    SALINITY=2
    LOCATION=3
    OTHER=4

    def self.is_valid(value)
      return value.between?(DEPTH, OTHER)
    end
  end

  has_attached_file :image, styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
