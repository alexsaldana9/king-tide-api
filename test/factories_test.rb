require 'test_helper'

class FactoriesTest < ActiveSupport::TestCase
  test 'creates different keys every time' do
    (1..100).each { create(:secret_key) }

    assert_equal SecretKey.count, SecretKey.pluck(:key).uniq.count
  end

  test 'creates different readings every time' do
    (1..100).each { create(:reading) }

    assert_equal Reading.count, Reading.pluck(:depth).uniq.count
    assert Reading.pluck(:units_depth).all? {|x| x == 'inches'}

    assert_equal Reading.count, Reading.pluck(:salinity).uniq.count
    assert Reading.pluck(:units_salinity).all? {|x| x == 'ppt'}

    assert_equal Reading.count, Reading.pluck(:description).uniq.count
    assert Reading.pluck(:approved).all? {|x| x == false}
  end
end
