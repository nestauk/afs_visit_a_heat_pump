require "test_helper"

class BookingTest < ActiveSupport::TestCase
  setup { @subject = bookings(:one) }

  test('belongs to event') { assert_instance_of(Event, @subject.event) }

  test('first_name required') { assert_present(:first_name) }

  test('last_name required') { assert_present(:last_name) }

  test('email required') { assert_present(:email) }

  test 'email format' do
    @subject.email = 'notvalid.com'
    @subject.valid?
    assert_error(:email, 'is invalid')
  end

  test('quantity required') { assert_present(:quantity) }

  test 'quantity must be greater than 0' do
    @subject.quantity = 0
    @subject.valid?
    assert_error(:quantity, 'must be greater than 0')
  end

  test 'quantity must be less than 5' do
    @subject.quantity = 5
    @subject.valid?
    assert_error(:quantity, 'must be less than 5')
  end

  test '#already_booked' do
    duplicate_booking = events(:one).bookings.new(email: @subject.email)
    duplicate_booking.valid?
    assert_error(
        :email,
        "already booked with #{@subject.email} - we've resent the booking confirmation email",
        subject: duplicate_booking
      )
    assert_email @subject.email, 'Booking confirmed - Visit a heat pump'
  end

  test '#already_booked not checked if cancelling booking' do
    @subject.cancelled_at = Time.now
    duplicate_booking = Booking.new(email: @subject.email)
    assert @subject.valid?
  end

  test '#no_places_left' do
    @subject.event.capacity = 0
    @subject.valid?
    assert_error(:quantity, 'no places left, try reducing the number of visitors')
  end

  test '#notify_host!' do
    ActionMailer::Base.deliveries = []
    @subject.notify_host!
    assert_email users(:one).email, 'New booking - Visit a heat pump'
  end

  test '#notify_visitor!' do
    ActionMailer::Base.deliveries = []
    @subject.notify_visitor!
    assert_email bookings(:one).email, 'Booking confirmed - Visit a heat pump'
  end
end
