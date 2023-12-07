class HostMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def new_booking(event, booking)
    @event = event
    @booking = booking
    mail(to: @event.host.user.email, subject: 'New booking - Visit a heat pump')
  end

  def booking_cancelled(event, booking)
    @event = event
    @booking = booking
    mail(to: @event.host.user.email, subject: 'Booking cancelled - Visit a heat pump')
  end
end
