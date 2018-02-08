require 'test_helper'

class SecretKeyTest < ActiveSupport::TestCase
  setup do
    @keys = (1...3).map { create(:secret_key).key }
  end

  test 'is_valid returns false for empty parameters' do
    assert_not SecretKey.is_valid(nil)
    assert_not SecretKey.is_valid('')
  end

  test 'is_valid returns false for invalid keys' do
    assert_not SecretKey.is_valid('incorrect')
    assert_not SecretKey.is_valid('invalid')
  end

  test 'is_valid returns true for valid keys' do
    @keys.each do |k|
      assert SecretKey.is_valid(k)
    end
  end
end
