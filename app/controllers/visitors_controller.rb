class VisitorsController < ApplicationController
  def search; end

   def index
    if params[:postcode]
      # TODO: handle geocode error, e.g. ECFY 0DF
      @hosts = Host.by_distance(origin: params[:postcode]).all
    else
      @hosts = Host.all
    end
  end
end
