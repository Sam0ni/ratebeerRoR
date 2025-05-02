class StylesController < ApplicationController
  before_action :set_style, only: %i[show]

  def index
    @styles = Style.all
  end

  def show
    @beers = Beer.where style_id: @style.id
  end

  def set_style
    @style = Style.find(params.expect(:id))
  end
end
