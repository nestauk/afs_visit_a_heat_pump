require "test_helper"

class HostTest < ActiveSupport::TestCase
  setup { @subject = hosts(:one) }

  test('has_one user') { assert_instance_of(User, @subject.user) }

  test('has many events') { assert_equal(3, @subject.events.size) }

  test('street_address required') { assert_present(:street_address) }

  test('city required') { assert_present(:city) }

  test('postcode required') { assert_present(:postcode) }

  test('property_type required') { assert_present(:property_type) }

  test('property_age required') { assert_present(:property_age) }

  test('profile_picture required') { assert_present(:profile_picture) }

  test('no_of_bedrooms required') { assert_present(:no_of_bedrooms) }

  test('hp_type required') { assert_present(:hp_type) }

  test('hp_manufacturer required') { assert_present(:hp_manufacturer) }

  test('hp_year_of_install required') { assert_present(:hp_year_of_install) }

  test 'no_of_bedrooms greater than 0' do
    @subject.no_of_bedrooms = 0
    @subject.valid?
    assert_error :no_of_bedrooms, 'must be greater than 0'
  end

  test 'hp_size greater than 0' do
    @subject.hp_size = 0
    @subject.valid?
    assert_error :hp_size, 'must be greater than 0'
  end

  test 'property_type included in PROPERTY_TYPES' do
    @subject.property_type = 'missing'
    @subject.valid?
    assert_error :property_type, 'is not included in the list'
  end

  test 'property_age included in PROPERTY_AGES' do
    @subject.property_age = 'missing'
    @subject.valid?
    assert_error :property_age, 'is not included in the list'
  end

  test 'hp_type included in HP_TYPES' do
    @subject.hp_type = 'missing'
    @subject.valid?
    assert_error :hp_type, 'is not included in the list'
  end

  test '#display_name' do
    assert_equal @subject.display_name, "Detached in London"
  end

  test '#subtitle' do
    assert_equal @subject.subtitle, "Air source heat pump in a 1920 - 1944 property, hosted by John."
  end
end
