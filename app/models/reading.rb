class Reading < ApplicationRecord

  has_many :photos

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
end


