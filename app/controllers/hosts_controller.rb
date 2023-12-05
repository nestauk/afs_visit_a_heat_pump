class HostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_host, only: %i[ show edit update ]

  def home
    @host = current_user.host
    @events = @host.events.active if @host
  end

  def past_events
    @host = current_user.host
    @events = @host.events.past if @host
  end

  def cancelled_events
    @host = current_user.host
    @events = @host.events.cancelled if @host
  end

  def show
    @events = @host.events.active
  end

  def new
    @host = Host.new
    @host.user = current_user
  end

  def edit
  end

  def create
    @host = Host.new(host_params)
    @host.user = current_user

    if @host.save
      redirect_to host_home_path, notice: "Host profile created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @host.update(host_params)
      redirect_to host_url(@host), notice: "Host profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_host
      @host = Host.find(params[:id])
    end

    def host_params
      params.require(:host).permit(
        :street_address, :city, :postcode, :property_type, :hp_type,
        :profile_picture, :no_of_bedrooms, :useful_info, :hp_manufacturer,
        :hp_size, :hp_year_of_install, :upcoming_dates
      )
    end
end
