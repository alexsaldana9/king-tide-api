# == Schema Information
#
# Table name: secret_keys
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#  key        :string
#

class SecretKey < ApplicationRecord
  def self.is_valid(secret)
    return false if not secret

    read_all_keys.include?(secret)
  end

  private

  def self.read_all_keys
    Rails.cache.fetch('SecretKey.AllKeys', expires_in: 1.minute) do
      array = SecretKey.distinct.pluck(:key).to_a
      Hash[array.collect { |item| [item, ""] } ]
    end
  end
end
