class Reading < ApplicationRecord

  has_many :photos

  def approve!
    self.approved = true
    self.save!
  end

  def delete!
    self.deleted = true
    self.save!
  end
end


