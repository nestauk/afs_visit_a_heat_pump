class VisitorMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def booking_confirmation(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Booking confirmed - Visit a heat pump')
  end

  def event_updated(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Event updated - Visit a heat pump')
  end

  def event_cancelled(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Event cancelled - Visit a heat pump')
  end
end
