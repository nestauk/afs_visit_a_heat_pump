# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class HostMailerPreview < ActionMailer::Preview
  def cancel_event
    user = User.new(first_name: 'Jane')
    host = Host.new(id: 1, user: user, city: 'London')
    event = Event.new(host: host, date: Date.today, start_at: Time.now, end_at: Time.now, capacity: 10)
    booking = Booking.new(event: event, email: 'test@example.com', first_name: 'John')
    HostMailer.cancel_event(event, booking).deliver_now
  end
end
