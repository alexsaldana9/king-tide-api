require 'test_helper'

class FactoriesTest < ActiveSupport::TestCase
  test 'returns different strings every time' do
    assert_equal 100, (1..100).map { FactoryBot.random_string }.uniq.count
  end

  test 'creates different keys every time' do
    (1..100).each { create(:secret_key) }

    assert_equal SecretKey.count, SecretKey.pluck(:key).uniq.count
  end
end
