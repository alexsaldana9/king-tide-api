require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  def setup
    @r1 = readings(:one)
  end

  test 'soft deletes the reading' do
    assert_equal false, @r1.deleted

    @r1.delete!

    assert_equal true, @r1.deleted
    assert_equal true, Reading.find_by_id(@r1.id).deleted

    @r1.delete!

    assert_equal true, @r1.deleted
    assert_equal true, Reading.find_by_id(@r1.id).deleted
  end

  test 'approves the reading' do
    assert_equal false, @r1.approved

    @r1.approve!

    assert_equal true, @r1.approved
    assert_equal true, Reading.find_by_id(@r1.id).approved

    @r1.approve!

    assert_equal true, @r1.approved
    assert_equal true, Reading.find_by_id(@r1.id).approved
  end
end
