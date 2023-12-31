class EventsController < ApplicationController
  before_action :authenticate_user!, :set_host
  before_action :set_event, :cannot_change_past_or_cancelled, only: %i[ edit update cancel ]
  before_action :cannot_access_records_of_other_hosts, only: %i[ new edit ]

  def new
    @event = @host.events.new
  end

  def edit
  end

  def create
    @event = @host.events.new(event_params)

    if @event.save
      redirect_to host_home_path, notice: "Event created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      @event.notify_changes!
      redirect_to host_home_path, notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    @event.cancel!
    redirect_to host_home_path
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

    def cannot_change_past_or_cancelled
      redirect_to host_home_path, alert: 'Unpermitted action' if @event.date.past? || @event.cancelled_at?
    end

    def cannot_access_records_of_other_hosts
      return redirect_to host_home_path if @host != current_user.host
    end
end
