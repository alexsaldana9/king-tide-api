require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  def setup
    @r1 = readings(:one)
  end

  test 'soft deletes the reading' do
    all_readings_count = Reading.with_deleted.count
    assert_not @r1.deleted?
    assert_equal all_readings_count, Reading.count
    assert_equal all_readings_count, Reading.pending.count
    assert_equal 0, Reading.approved.count

    @r1.destroy

    assert @r1.deleted?
    assert Reading.with_deleted.find(@r1.id).deleted?
    assert_equal all_readings_count - 1, Reading.count
    assert_equal all_readings_count - 1, Reading.pending.count
    assert_equal 0, Reading.approved.count

    @r1.destroy

    assert @r1.deleted?
    assert Reading.with_deleted.find(@r1.id).deleted?
    assert_equal all_readings_count - 1, Reading.count
    assert_equal all_readings_count - 1, Reading.pending.count
    assert_equal 0, Reading.approved.count
  end

  test 'approves the reading' do
    all_readings_count = Reading.with_deleted.count
    assert_not @r1.approved?
    assert_equal all_readings_count, Reading.count
    assert_equal all_readings_count, Reading.pending.count
    assert_equal 0, Reading.approved.count

    @r1.approve!

    assert @r1.approved?
    assert Reading.find(@r1.id).approved?
    assert_equal all_readings_count, Reading.count
    assert_equal all_readings_count - 1, Reading.pending.count
    assert_equal 1, Reading.approved.count

    @r1.approve!

    assert @r1.approved?
    assert Reading.find(@r1.id).approved?
    assert_equal all_readings_count, Reading.count
    assert_equal all_readings_count - 1, Reading.pending.count
    assert_equal 1, Reading.approved.count
  end
end
