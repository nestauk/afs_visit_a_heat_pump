class BookingsController < ApplicationController
  before_action :set_host, :set_event, only: %i[ new create ]

  def new
    @booking = Booking.new
  end

  def edit
  end

  def create
    @booking = @event.bookings.new(booking_params)

    if @booking.save
      redirect_to @host, notice: "Booking created."
    else
      render :new, status: :unprocessable_entity
    end
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
