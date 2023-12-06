# Preview all emails at http://localhost:3000/rails/mailers/host_mailer
class HostMailerPreview < ActionMailer::Preview
  def initialize(attrs)
    @user = User.new(first_name: 'Jane')
    @host = Host.new(id: 1, user: @user, street_address: '123 Street Address', city: 'London', postcode: '123 ABC', property_type: 'Detached')
    @event = Event.new(host: @host, date: Date.today, start_at: Time.now, end_at: Time.now, capacity: 10)
    @booking = Booking.new(event: @event, email: 'test@example.com', first_name: 'John')
  end

  def updated_event
    HostMailer.updated_event(@event, @booking).deliver_now
  end

  def cancel_event
    HostMailer.cancel_event(@event, @booking).deliver_now
  end
end
