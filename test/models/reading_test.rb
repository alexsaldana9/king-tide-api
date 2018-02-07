require 'test_helper'

class ReadingTest < ActiveSupport::TestCase
  def setup
    @r1 = readings(:one)
  end

  test 'soft deletes the reading' do
    assert_not @r1.deleted?

    @r1.delete!

    assert @r1.deleted?
    assert Reading.find_by_id(@r1.id).deleted?

    @r1.delete!

    assert @r1.deleted?
    assert Reading.find_by_id(@r1.id).deleted?
  end

  test 'approves the reading' do
    assert_not @r1.approved?

    @r1.approve!

    assert @r1.approved?
    assert Reading.find_by_id(@r1.id).approved?

    @r1.approve!

    assert @r1.approved?
    assert Reading.find_by_id(@r1.id).approved?
  end
end
