require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup { @subject = events(:one) }

  test 'active scope returns future events that and are not cancelled' do
    assert_equal 1, Event.active.count
  end

  test 'past scope returns events with date in the past that are not cancelled' do
    assert_equal 1, Event.past.count
  end

  test 'past scope returns events with cancelled_at' do
    assert_equal 1, Event.cancelled.count
  end

  test('belongs to host') { assert_instance_of(Host, @subject.host) }

  test('has many bookings') { assert_equal(2, @subject.bookings.size) }

  test('date required') { assert_present(:date) }

  test('start_at required') { assert_present(:start_at) }

  test('end_at required') { assert_present(:end_at) }

  test('capacity required') { assert_present(:capacity) }

  test 'date must be in the future' do
    @subject.date = 1.day.ago
    @subject.valid?
    assert_error(:date, 'cannot be in the past')
  end

  test 'end time cannot be same as start time' do
    @subject.end_at = @subject.start_at
    @subject.valid?
    assert_error(:end_at, 'end time must be after start time')
  end

  test 'end time must be after start time' do
    @subject.end_at = @subject.start_at - 1.hour
    @subject.valid?
    assert_error(:end_at, 'end time must be after start time')
  end

  test 'capacity must be greater than 0' do
    @subject.capacity = 0
    @subject.valid?
    assert_error(:capacity, 'must be greater than 0')
  end

  test 'capacity must be less than 101' do
    @subject.capacity = 101
    @subject.valid?
    assert_error(:capacity, 'must be less than or equal to 100')
  end

  test 'capacity must be greater than bookings already made' do
    @subject.capacity = 1
    @subject.valid?
    assert_error(:capacity, '2 places already booked, event capacity must be 2 or more')
  end
end
