class SecretKey < ApplicationRecord
  def self.is_valid(secret)
    return false if not secret

    read_all_keys.include?(secret)
  end

  private

  def self.read_all_keys
    Rails.cache.fetch('SecretKey.AllKeys', expires_in: 1.minute) do
      SecretKey
          .select(:key)
          .distinct
          .map {|s| s.key}
          .to_a
          .sort
    end
  end
end
