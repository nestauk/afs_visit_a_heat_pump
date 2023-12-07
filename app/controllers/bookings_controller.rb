class BookingsController < ApplicationController
  before_action :set_host, :set_event, only: %i[ new create ]

  def new
    return redirect_to host_path(@host), alert: 'Event has no more places' if @event.capacity_reached?
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = @event.bookings.new(booking_params)

    if @booking.save
      @booking.notify_visitor!
      @booking.notify_host!
      redirect_to @host, notice: "Booking created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def review_cancellation
    @booking = Booking.find_by_token_for(:cancellation, params[:token])
    return redirect_to hosts_path, alert: 'Booking not found' unless @booking
    @event = @booking.event
    @host = @event.host
  end

  def confirm_cancellation
    @booking = Booking.find_by_token_for(:cancellation, params[:token])
    return redirect_to hosts_path, alert: 'Booking not found' unless @booking

    @booking.update(cancelled_at: Time.now)
    redirect_to hosts_path, notice: 'Booking cancelled - email confirmation has been sent'
    VisitorMailer.booking_cancelled(@booking.event, @booking).deliver_now
    HostMailer.booking_cancelled(@booking.event, @booking).deliver_now
  end

  private
    def set_host
      @host = Host.find_by(id: params[:host_id])
    end

    def set_event
      @event = Event.find_by(id: params[:event_id])
    end

    def booking_params
      params.require(:booking).permit(:events_id, :first_name, :last_name, :email, :quantity, :notes)
    end
end
