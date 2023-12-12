class VisitorMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def booking_confirmation(event, booking)
    @event = event
    @booking = booking
    @token = @booking.generate_token_for(:cancellation)
    mail(to: @booking.email, subject: 'Booking confirmed - Visit a heat pump')
  end

  def booking_cancelled(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Booking cancelled - Visit a heat pump')
  end

  def event_updated(event, booking)
    @event = event
    @booking = booking
    @token = @booking.generate_token_for(:cancellation)
    mail(to: @booking.email, subject: 'Event updated - Visit a heat pump')
  end

  def event_cancelled(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Event cancelled - Visit a heat pump')
  end

  def event_upcoming(event, booking)
    @event = event
    @booking = booking
    @token = @booking.generate_token_for(:cancellation)
    mail(to: @booking.email, subject: 'Your visit is in 3 days - Visit a heat pump')
  end
end
