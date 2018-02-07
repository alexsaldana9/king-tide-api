class Reading < ApplicationRecord

  has_many :photos

  def approve!
    self.approved = true
    save!
  end

  def delete!
    self.deleted = true
    save!
  end
end


