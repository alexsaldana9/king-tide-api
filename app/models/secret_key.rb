class SecretKey < ApplicationRecord
  def self.is_valid(secret)
    return false if not secret

    read_all_keys.include?(secret)
  end

  private

  def self.read_all_keys
    Rails.cache.fetch('SecretKey.AllKeys', expires_in: 1.minute) do
      SecretKey.distinct.pluck(:key)
    end
  end
end
