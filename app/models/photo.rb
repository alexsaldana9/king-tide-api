class Photo < ApplicationRecord
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