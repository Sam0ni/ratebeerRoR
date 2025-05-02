class PlacesController < ApplicationController
  def index
  end

  def show
    if latest_search.nil?
      redirect_to places_path
    else
      place = BeermappingApi.place_with_id(params[:id], latest_search)
      if place
        @place = place
      else
        redirect_to places_path, notice: "No location with id #{params[:id]} in #{latest_search}"
      end
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_search] = params[:city]
      render :index, status: 418
    end
  end
end
