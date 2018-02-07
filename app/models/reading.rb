class Reading < ApplicationRecord

  has_many :photos, dependent: :destroy

  before_save :configure_status

  scope :existent, -> { where(deleted: false) }
  scope :approved, -> { existent.where(approved: true) }
  scope :pending, -> { existent.where(approved: false) }

  def approve!
    self.approved = true
    self.save!
  end

  def delete!
    self.deleted = true
    self.save!
  end

  private

  def configure_status
    self.approved = false unless self.approved
    self.deleted = false unless self.deleted
  end
end


