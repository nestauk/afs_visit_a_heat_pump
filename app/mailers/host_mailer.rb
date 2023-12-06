class HostMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def updated_event(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Event updated - Visit a heat pump')
  end

  def cancel_event(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Event cancelled - Visit a heat pump')
  end
end
