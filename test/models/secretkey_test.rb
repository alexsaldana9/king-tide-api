require 'test_helper'

class SecretKeyTest < ActiveSupport::TestCase
  test 'is_valid returns false for empty parameters' do
    assert_equal false, SecretKey.is_valid(nil)
    assert_equal false, SecretKey.is_valid('')
  end

  test 'is_valid returns false for invalid keys' do
    assert_equal false, SecretKey.is_valid('incorrect')
    assert_equal false, SecretKey.is_valid('invalid')
  end

  test 'is_valid returns true for valid keys' do
    assert_equal true, SecretKey.is_valid('keysample')
    assert_equal true, SecretKey.is_valid('another key')
  end
end
