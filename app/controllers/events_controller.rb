class EventsController < ApplicationController
  before_action :authenticate_user!, :set_host
  before_action :set_event, only: %i[ edit update ]

  def new
    @event = @host.events.new
  end

  def edit
  end

  def create
    @event = @host.events.new(event_params)

    if @event.save
      redirect_to root_path, notice: "Event created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to root_path, notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_host
      @host = Host.find(params[:host_id])
    end

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:date, :start_at, :end_at, :capacity)
    end
end
