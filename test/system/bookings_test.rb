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

  # TODO: test 'visitor can cancel event'

  def complete_booking_form
    fill_in 'First name', with: 'Visitor'
    fill_in 'Last name', with: 'One'
    fill_in 'Email', with: @visitor_email
    select 1, from: 'How many visitors will there be?'
    click_button 'Book'
  end
end
