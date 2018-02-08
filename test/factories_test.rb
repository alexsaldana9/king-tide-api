require 'test_helper'

class FactoriesTest < ActiveSupport::TestCase
  test 'returns different strings every time' do
    assert_equal 100, (1..100).map { FactoryBot.random_string }.uniq.count
  end

  test 'returns different floats within range every time' do
    assert (1..100).map { FactoryBot.random_float }.all? {|n| n.is_a? Float}

    assert_in_delta 100, (1..100).map { FactoryBot.random_float }.uniq.count, 40

    assert_not (1..100).map { FactoryBot.random_float(2.5, 3.8) }.any? {|n| n < 2.5 || n > 3.8}
  end

  test 'returns different ints within range every time' do
    assert (1..100).map { FactoryBot.random_int }.all? {|n| n.is_a? Integer}

    assert_in_delta 100, (1..100).map { FactoryBot.random_int }.uniq.count, 40

    assert_not (1..100).map { FactoryBot.random_int(10, 9000) }.any? {|n| n < 10 || n > 9000}
  end

  test 'creates different keys every time' do
    (1..100).each { create(:secret_key) }

    assert_equal SecretKey.count, SecretKey.pluck(:key).uniq.count
  end

  test 'creates different readings every time' do
    (1..100).each { create(:reading) }

    assert_in_delta Reading.count, Reading.pluck(:depth).uniq.count, 10
    assert Reading.pluck(:units_depth).all? {|x| x == 'inches'}

    assert_in_delta Reading.count, Reading.pluck(:salinity).uniq.count, 10
    assert Reading.pluck(:units_salinity).all? {|x| x == 'ppt'}

    assert_equal Reading.count, Reading.pluck(:description).uniq.count
    assert Reading.pluck(:approved).all? {|x| x == false}
  end
end
