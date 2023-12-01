class HostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_host, only: %i[ show edit update ]

  def home
    @host = current_user.host
    @events = @host.events.order(:date) if @host
  end

  def show
    @events = @host.events.where('date > ?', Date.today).order(:date)
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
        :street_address, :city, :postcode, :property_type, :hp_type, :profile_picture
      )
    end
end
