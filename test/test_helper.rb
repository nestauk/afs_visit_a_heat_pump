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
end
