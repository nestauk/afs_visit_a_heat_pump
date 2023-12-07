require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @host = hosts(:one)
    @event = events(:one)
    @visitor_email = 'manual.visitor@email.com'
  end

  test 'visitor can book event' do
    visit host_path(@host)
    click_on 'Book a visit'
    complete_booking_form
    assert_current_path host_path(@host)
    assert_text 'Booking created'
  end

  test 'visitor recieves email confirmation of booking' do
    ActionMailer::Base.deliveries = []
    visit new_host_event_booking_path(@host, @event)
    complete_booking_form
    assert_email_with_sleep @visitor_email, 'Booking confirmed - Visit a heat pump'
  end

  test 'host recieves email confirmation of booking' do
    ActionMailer::Base.deliveries = []
    visit new_host_event_booking_path(@host, @event)
    complete_booking_form
    assert_email_with_sleep @host.user.email, 'New booking - Visit a heat pump'
  end

  test 'visitor cannot book event when capacity reached' do
    @event.update(capacity: @event.active_bookings_count)
    visit new_host_event_booking_path(@host, @event)
    assert_current_path host_path(@host)
    assert_text 'Event has no more places'
  end

  test 'visitor can cancel event' do
    ActionMailer::Base.deliveries = []
    token = bookings(:one).generate_token_for(:cancellation)
    visit review_booking_cancellation_path(token)
    accept_confirm { click_on 'Confirm cancellation' }
    assert_current_path hosts_path
    assert_text 'Booking cancelled - email confirmation has been sent'
    assert_email bookings(:one).email, 'Booking cancelled - Visit a heat pump' # notify visitor
    assert_email users(:one).email, 'Booking cancelled - Visit a heat pump' # notify host
  end

  test 'booking to cancel not found' do
    visit review_booking_cancellation_path('missing')
    assert_current_path hosts_path
    assert_text 'Booking not found'
  end

  test 'booking already cancelled' do
    token = bookings(:one).generate_token_for(:cancellation)
    visit review_booking_cancellation_path(token)
    accept_confirm { click_on 'Confirm cancellation' }
    visit review_booking_cancellation_path(token)
    assert_text 'Booking not found'
  end

  def complete_booking_form
    fill_in 'First name', with: 'Visitor'
    fill_in 'Last name', with: 'One'
    fill_in 'Email', with: @visitor_email
    select 1, from: 'How many visitors will there be?'
    click_button 'Book'
  end
end
