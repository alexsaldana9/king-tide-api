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

class Reading < ApplicationRecord
  acts_as_paranoid

  has_many :photos, dependent: :destroy

  before_save :set_pending_by_default

  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }

  def approve!
    self.approved = true
    self.save!
  end

  private

  def set_pending_by_default
    self.approved = false unless self.approved
  end
end


