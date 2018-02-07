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


