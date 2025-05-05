class RatingsController < ApplicationController
  def index
    @top_breweries = Brewery.top(3)
    @top_styles = Style.top(3)
    @top_beers = Beer.top(3)
    @active_users = User.most_active(3)
    @recent_ratings = Rating.recent
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to current_user
  end
end
