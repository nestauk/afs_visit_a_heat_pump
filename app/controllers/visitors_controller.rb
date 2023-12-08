class VisitorsController < ApplicationController
   def index
    @postcode = params.dig(:q, :postcode)

    if @postcode.present?
      begin
        hosts_by_distance = Host.by_distance(origin: @postcode).all
      rescue => err
        msg = "Could not find postcode #{@postcode}"
        @postcode = nil
        return redirect_to hosts_path, alert: msg
      end

      @q = hosts_by_distance.ransack(params[:q])
      @hosts = @q.result.page(params[:page])
    else
      @q = Host.ransack(params[:q])
      @hosts = @q.result(distinct: true).page(params[:page])
    end
  end
end
