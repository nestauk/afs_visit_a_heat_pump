class HostMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def cancel_event(event, booking)
    @event = event
    @booking = booking
    mail(to: @booking.email, subject: 'Event cancelled - Visit a heat pump')
  end
end
