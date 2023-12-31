class HostsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show follow unfollow ]
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
    return redirect_back fallback_location: hosts_path, alert: 'Host not found' unless current_user&.host == @host || @host.published
    @events = @host.events.active
    @follower = Follower.new
  end

  def follow
    @host = Host.find_by(id: params[:id])
    @events = @host.events.active
    @follower = @host.followers.new(follower_params)

    if @host.save # TODO: refactor
      redirect_to host_path(@host), notice: 'Now following host'
    else
      render :show, status: :unprocessable_entity
    end
  end

  def new
    return redirect_to host_home_path, alert: 'Access denied' if current_user&.host
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
      redirect_to host_path(@host), notice: "Host profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_host
      @host = Host.find_by(id: params[:id])
      return redirect_back fallback_location: hosts_path, alert: 'Host not found' unless @host
      unless action_name == 'show'
        return redirect_to host_home_path, alert: 'Access denied' if @host != current_user.host
      end
    end

    def host_params
      params.require(:host).permit(
        :street_address, :city, :postcode, :property_type, :hp_type,
        :profile_picture, :no_of_bedrooms, :useful_info, :hp_manufacturer,
        :hp_size, :hp_year_of_install, :upcoming_dates, :property_age,
        :description
      )
    end

    def follower_params
      params.require(:follower).permit(:email)
    end
end
