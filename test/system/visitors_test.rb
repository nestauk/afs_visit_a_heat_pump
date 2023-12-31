require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @host = hosts(:one)
    visit hosts_path
  end

  test 'list only published hosts' do
    @host.update(published: false)
    visit hosts_path
    assert_link 'View', count: 1
  end

  test 'no postcode' do
    assert_link 'View', count: 2
  end

  test 'valid postcode' do
    Host.expects(:by_distance).with(origin: @host.postcode)
        .returns(Host.where(postcode: @host.postcode))
    Host.any_instance.stubs(:distance_from).returns(10)

    fill_in 'Postcode', with: @host.postcode
    click_on 'Filter'
    assert_link 'View', count: 2
  end

  test 'invalid postcode' do
    fill_in 'Postcode', with: 'ERROR'
    click_on 'Filter'
    assert_text 'Could not find postcode ERROR'
  end

  test 'filter by heat pump type' do
    select @host.hp_type, from: :q_hp_type_in
    click_on 'Filter'
    assert_link 'View', count: 1
  end

  test 'filter by property type' do
    select @host.property_type, from: :q_property_type_in
    click_on 'Filter'
    assert_link 'View', count: 1
  end

  test 'can follow host' do
    visit host_path(hosts(:two))
    fill_in :follower_email, with: 'follower@email.com'
    click_on 'Follow host'
    sleep 1
    assert_equal 1, hosts(:two).followers.count
  end
end
