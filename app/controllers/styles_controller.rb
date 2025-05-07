class StylesController < ApplicationController
  before_action :set_style, only: %i[show]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_admin, only: %i[destroy]

  def index
    @styles = Style.all
  end

  def show
    @beers = Beer.where style_id: @style.id
  end

  def destroy
    @style.destroy!

    respond_to do |format|
      format.html { redirect_to breweries_path, status: :see_other, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_style
    @style = Style.find(params.expect(:id))
  end
end
