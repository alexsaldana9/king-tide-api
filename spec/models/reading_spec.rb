require 'rails_helper'

RSpec.describe Reading, type: :model do
  before do
    @r1 = (1...10).map { create(:reading) }.first
  end

  it 'soft deletes the reading' do
    all_readings_count = Reading.with_deleted.count
    expect(@r1.deleted?).not_to eq(true)
    expect(Reading.count).to eq(all_readings_count)
    expect(Reading.pending.count).to eq(all_readings_count)
    expect(Reading.approved.count).to eq(0)

    @r1.destroy

    expect(@r1.deleted?).to eq(true)
    expect(Reading.with_deleted.find(@r1.id).deleted?).to eq(true)
    expect(Reading.count).to eq(all_readings_count - 1)
    expect(Reading.pending.count).to eq(all_readings_count - 1)
    expect(Reading.approved.count).to eq(0)

    @r1.destroy

    expect(@r1.deleted?).to eq(true)
    expect(Reading.with_deleted.find(@r1.id).deleted?).to eq(true)
    expect(Reading.count).to eq(all_readings_count - 1)
    expect(Reading.pending.count).to eq(all_readings_count - 1)
    expect(Reading.approved.count).to eq(0)
  end

  it 'approves the reading' do
    all_readings_count = Reading.with_deleted.count
    expect(@r1.approved?).not_to eq(true)
    expect(Reading.count).to eq(all_readings_count)
    expect(Reading.pending.count).to eq(all_readings_count)
    expect(Reading.approved.count).to eq(0)

    @r1.approve!

    expect(@r1.approved?).to eq(true)
    expect(Reading.find(@r1.id).approved?).to eq(true)
    expect(Reading.count).to eq(all_readings_count)
    expect(Reading.pending.count).to eq(all_readings_count - 1)
    expect(Reading.approved.count).to eq(1)

    @r1.approve!

    expect(@r1.approved?).to eq(true)
    expect(Reading.find(@r1.id).approved?).to eq(true)
    expect(Reading.count).to eq(all_readings_count)
    expect(Reading.pending.count).to eq(all_readings_count - 1)
    expect(Reading.approved.count).to eq(1)
  end
end
