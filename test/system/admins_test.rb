require "application_system_test_case"

class AdminsTest < ApplicationSystemTestCase
  test 'user must signed in to visit admin pages' do
    visit blazer_path
    assert_current_path new_user_session_path
    assert_text 'You need to sign in or sign up before continuing'
  end

  # TODO: test 'user must be admin to visit admin pages'

  test 'admin user can visit admin pages' do
    sign_in(users(:admin))
    sleep 1
    visit blazer_path
    assert_current_path blazer_path
  end
end
