require "application_system_test_case"

class HostsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @host = hosts(:one)
  end

  test "can sign up" do
    complete_sign_up_form
    assert_current_path host_home_path
  end

  test "can sign in" do
    sign_in
    assert_current_path host_home_path
  end

  test "can create profile" do
    complete_sign_up_form
    click_on 'Complete your profile'
    assert_current_path new_host_path
    complete_host_form
    assert_current_path host_home_path
  end

  test "can create event" do
    sign_in
    click_on 'Add event'
    complete_event_form
    assert_link 'Edit', href: edit_host_event_path(@host, @host.events.last)
  end

  def complete_sign_up_form
    visit new_user_registration_path
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: 'john.doe@example.com'
    fill_in :user_password, with: 'password123'
    fill_in :user_password_confirmation, with: 'password123'
    check :user_accepted_terms_at
    click_button 'Sign up'
  end

  def complete_host_form
    fill_in 'Street address', with: @host.street_address
    fill_in 'City', with: @host.city
    fill_in 'Postcode', with: @host.postcode
    select @host.property_type, from: 'Property type'
    fill_in 'Number of bedrooms', with: @host.no_of_bedrooms
    attach_file :host_profile_picture, Rails.root + "test/fixtures/files/profile_pic.jpg"
    select @host.hp_type, from: 'Heat pump type'
    fill_in 'Manufacturer', with: @host.hp_manufacturer
    select @host.hp_year_of_install, from: 'Year of installation'
    mock_geocoding_success!
    click_button 'Save'
  end

  def complete_event_form
    fill_in 'Date', with: 3.days.from_now
    select 10, from: 'Start time'
    select 13, from: 'End time'
    fill_in 'Maximum number of visitors', with: 10
    click_button 'Save'
  end
end
