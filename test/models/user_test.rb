require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @subject = users(:one)
    @password_msg = 'must contain at least one uppercase letter, one lowercase letter, and one number'
  end

  test('belongs to host') { assert_instance_of(Host, @subject.host) }

  test('email required') { assert_present(:email) }

  test('first_name required') { assert_present(:first_name) }

  test('last_name required') { assert_present(:last_name) }

  test('accepted_terms_at required') { assert_present(:accepted_terms_at) }

  test 'valid password' do
    @subject.password = 'Password123'
    assert @subject.valid?
  end

  test 'password must be at least 8 characters' do
    @subject.password = 'short'
    @subject.valid?
    assert_error :password, 'is too short (minimum is 8 characters)'
  end

  test 'password must include lowercase letters' do
    @subject.password = 'PASSWORD123'
    @subject.valid?
    assert_error :password, @password_msg
  end

  test 'password must include uppercase letters' do
    @subject.password = 'password123'
    @subject.valid?
    assert_error :password, @password_msg
  end

  test 'password must include numbers' do
    @subject.password = 'passwordONE'
    @subject.valid?
    assert_error :password, @password_msg
  end
end
