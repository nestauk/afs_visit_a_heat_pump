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

  test 'editing event with bookings notifies visitors' do
    ActionMailer::Base.deliveries = []
    event = @host.events.last
    sign_in
    click_on 'Edit'
    fill_in 'Date', with: 7.days.from_now
    click_button 'Save'
    event.bookings.pluck(:email).each do |to|
      assert_email_with_sleep to, "Event updated - Visit a heat pump"
    end
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
    ActionMailer::Base.deliveries = []
    event = @host.events.last
    sign_in
    click_on 'Edit'
    accept_confirm { click_on 'cancel the event' }
    event.bookings.pluck(:email).each do |to|
      assert_email_with_sleep to, "Event cancelled - Visit a heat pump"
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

  test 'can only create events for own host account' do
    sign_in
    sleep 1
    visit new_host_event_path(hosts(:two))
    assert_current_path host_home_path
  end

  test 'can only edit events for own host account' do
    sign_in
    sleep 1
    visit edit_host_event_path(hosts(:two), events(:one))
    assert_current_path host_home_path
  end

  def complete_event_form
    fill_in 'Date', with: 3.days.from_now
    select 10, from: 'Start time'
    select 13, from: 'End time'
    fill_in 'Maximum number of visitors', with: 10
    click_button 'Save'
  end
end
