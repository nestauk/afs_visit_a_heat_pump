# Preview all emails at http://localhost:3000/rails/mailers
class VisitorMailerPreview < ActionMailer::Preview
  def initialize(attrs)
    @user = User.new(first_name: 'Jane')
    @host = Host.new(id: 1, user: @user, street_address: '123 Street Address', city: 'London', postcode: '123 ABC', property_type: 'Detached')
    @event = Event.new(host: @host, date: Date.today, start_at: Time.now, end_at: Time.now, capacity: 10)
    @booking = Booking.new(event: @event, email: 'visitor@example.com', first_name: 'John')
  end

  def booking_confirmation
    VisitorMailer.booking_confirmation(@event, @booking).deliver_now
  end

  def event_updated
    VisitorMailer.event_updated(@event, @booking).deliver_now
  end

  def event_cancelled
    VisitorMailer.event_cancelled(@event, @booking).deliver_now
  end
end
