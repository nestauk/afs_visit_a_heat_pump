ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'mocha/minitest'
class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    Geokit::Geocoders::MultiGeocoder.stubs(:geocode).raises(RuntimeError,
      'Use mock_geocoding_success! or mock_geocoding_failure! in your test')
  end

  def mock_geocoding_success!
    geocode_payload = Geokit::GeoLoc.new(:lat => 123.456, :lng => 123.456)
    geocode_payload.success = true
    Geokit::Geocoders::MultiGeocoder.expects(:geocode).returns(geocode_payload)
  end

  def mock_geocoding_failure!
    geocode_payload = Geokit::GeoLoc.new
    geocode_payload.success = false
    Geokit::Geocoders::MultiGeocoder.expects(:geocode).returns(geocode_payload)
  end

  def assert_error(key, msg, subject: @subject)
    assert_includes(subject.errors[key], msg)
  end

  def assert_present(key, msg: "can't be blank", subject: @subject, value: nil)
    subject.send("#{key}=", value)
    subject.valid?
    assert_error(key, msg)
  end

  def assert_email(recipient, subject)
    deliveries = ActionMailer::Base.deliveries
    email = deliveries.find { |e| e.to[0] == recipient }
    assert_equal recipient, email.to[0]
    assert_equal email.subject, subject
  end

  def assert_email_with_sleep(recipient, subject)
    sleep 1 # ensure email sent, not ideas
    assert_email(recipient, subject)
  end
end
