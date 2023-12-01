class HostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_host, only: %i[ show edit update ]

  def home
    @host = current_user.host
  end

  def show
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
      redirect_to root_path, notice: "Host profile created."
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
      params.require(:host).permit(:street_address, :city, :postcode, :lat, :lng, :property_type, :hp_type)
    end
end
