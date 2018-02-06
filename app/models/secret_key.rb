class SecretKey < ApplicationRecord
  def self.is_valid(secret)
    if not secret
      return false
    end

    return SecretKey.where(key: secret).empty? == false
  end
end
