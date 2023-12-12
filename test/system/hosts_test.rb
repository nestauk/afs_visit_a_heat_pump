require "application_system_test_case"

class HostsTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    @host = hosts(:one)
  end

  test 'can sign up' do
    complete_sign_up_form
    assert_current_path new_host_path
  end

  test 'can sign in' do
    sign_in
    assert_current_path host_home_path
  end

  test 'can create profile' do
    complete_sign_up_form
    complete_host_form
    assert_current_path host_home_path
    assert_text 'Host profile created'
  end

  test 'cannot create more than one profile' do
    sign_in
    sleep 1
    visit new_host_path
    assert_current_path host_home_path
    assert_text 'Access denied'
  end

  test 'can edit profile' do
    sign_in
    click_on 'Edit profile'
    attach_file :host_profile_picture, Rails.root + "test/fixtures/files/profile_pic.jpg"
    fill_in 'Number of bedrooms', with: 4
    click_button 'Save'
    assert_current_path host_path(@host)
    assert_text 'Host profile updated'
  end

  test 'cannot edit the profile of other hosts' do
    sign_in
    sleep 1
    visit edit_host_path(hosts(:two))
    assert_current_path host_home_path
    assert_text 'Access denied'
  end

  test 'can view public profile' do
    sign_in
    click_on 'View public profile'
    assert_current_path host_path(@host)
  end

  test 'can view public profile of other hosts' do
    path = host_path(hosts(:two))
    visit path
    assert_current_path path
  end

  test 'public host profile not found' do
    visit host_path('missing')
    assert_current_path hosts_path
    assert_text 'Host not found'
  end

  test 'public profile not published' do
    @host.update(published: false)
    visit host_path(@host)
    assert_text 'Host not found'
  end

  test 'can view unpublished public profile when signed in' do
    @host.update(published: false)
    sign_in
    sleep 1
    visit host_path(@host)
    assert_current_path host_path(@host)
  end

  def complete_sign_up_form
    visit new_user_registration_path
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: 'john.doe@example.com'
    fill_in :user_password, with: 'Password123'
    fill_in :user_password_confirmation, with: 'Password123'
    check :user_accepted_terms_at
    click_button 'Register'
  end

  def complete_host_form
    fill_in 'Street address', with: @host.street_address
    fill_in 'City', with: @host.city
    fill_in 'Postcode', with: @host.postcode
    select @host.property_type, from: 'Property type'
    fill_in 'Number of bedrooms', with: @host.no_of_bedrooms
    select @host.property_age, from: 'Property age'
    attach_file :host_profile_picture, Rails.root + "test/fixtures/files/profile_pic.jpg"
    select @host.hp_type, from: 'Heat pump type'
    fill_in 'Manufacturer', with: @host.hp_manufacturer
    select @host.hp_year_of_install, from: 'Year of installation'
    mock_geocoding_success!
    click_button 'Save'
  end
end
