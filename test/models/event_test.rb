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

  test 'in_3_days scope returns events in 3 days time' do
    assert_equal 1, Event.in_3_days.count # 3 days from now

    @subject.update(date: 4.days.from_now)
    assert_equal 0, Event.in_3_days.count

    @subject.update(date: 2.days.from_now)
    assert_equal 0, Event.in_3_days.count
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
    bookings(:two).update!(cancelled_at: nil)
    @subject.capacity = 1
    @subject.valid?
    assert_error(:capacity, '2 places already booked, event capacity must be 2 or more')
  end

  test '#active_bookings_count' do
    assert_equal 2, Booking.count
    assert_equal 1, @subject.active_bookings_count
  end

  test '#capacity_reached?' do
    @subject.capacity = 1
    assert @subject.capacity_reached?
  end

  test '#cancel!' do
    ActionMailer::Base.deliveries = []
    assert_nil @subject.cancelled_at
    @subject.cancel!
    assert_instance_of ActiveSupport::TimeWithZone, @subject.cancelled_at
    assert_email bookings(:one).email, 'Event cancelled - Visit a heat pump'
  end

  # TODO: test '#notify_changes!'
end
