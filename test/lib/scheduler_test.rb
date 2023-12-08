require 'test_helper'

class SchedulerTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @event = events(:one)
    @booking = bookings(:one)

    AfsVisitAHeatPump::Application.load_tasks
    Rake::Task['scheduler:notify'].invoke
  end

  test 'host notified when event in 3 days' do
    assert_email_with_sleep @user.email, 'Your event is in 3 days - Visit a heat pump'
  end

  test 'visitor notified when event in 3 days' do
    assert_email_with_sleep @booking.email, 'Your visit is in 3 days - Visit a heat pump'
  end

  test 'host and visitor not notified when event not in 3 days' do
    ActionMailer::Base.deliveries = []
    in_7_days = @event.dup
    in_7_days.date = 7.days.from_now
    in_7_days.save!
    Rake::Task['scheduler:notify'].invoke
    assert_equal [], ActionMailer::Base.deliveries
  end
end
