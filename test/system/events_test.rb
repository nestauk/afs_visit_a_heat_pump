require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @host = hosts(:one)
  end

  test 'can create event' do
    sign_in
    click_on 'Add event'
    complete_event_form
    assert_link 'Edit', href: edit_host_event_path(@host, @host.events.last)
  end

  test 'can edit event' do
    sign_in
    click_on 'Edit'
    fill_in 'Maximum number of visitors', with: 20
    click_button 'Save'
    assert_current_path host_home_path
    assert_text 'Event updated'
  end

  test 'can cancel event' do
    event = @host.events.last
    sign_in
    click_on 'Edit'
    accept_confirm { click_on 'cancel the event' }
    click_on 'Cancelled events'
    assert_text event.date.strftime("%A %d %b %G"), count: 2
    assert_no_link edit_host_event_path(@host, event)
  end

  test 'cancelling event with bookings notifies visitors' do
    event = @host.events.last
    booking = event.bookings.last
    sign_in
    click_on 'Edit'
    accept_confirm { click_on 'cancel the event' }
    sleep 1 # ensure mail delivered - not ideal but does the job
    ActionMailer::Base.deliveries do |email|
      assert_equal email.subject, "Event cancelled - Visit a heat pump"
      assert_includes email.to, booking.email
    end
  end

  test 'can see past events' do
    event = @host.events.last
    event.update_column(:date, 1.day.ago)
    sign_in
    click_on 'Past events'
    assert_text event.date.strftime("%A %d %b %G"), count: 1
    assert_no_link edit_host_event_path(@host, event)
  end

  test 'cannot edit past event' do
    sign_in
    sleep 1
    visit edit_host_event_path(@host, events(:past))
    assert_current_path host_home_path
    assert_text 'Unpermitted action'
  end

  def complete_event_form
    fill_in 'Date', with: 3.days.from_now
    select 10, from: 'Start time'
    select 13, from: 'End time'
    fill_in 'Maximum number of visitors', with: 10
    click_button 'Save'
  end
end
