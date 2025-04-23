class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[ show edit update destroy ]

  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    already_in = current_user.beer_clubs.map {|club| club.name}
    @beer_clubs = BeerClub.where.not(name: already_in)
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.new params.require(:membership).permit(:beer_club_id)
    @membership.user = current_user

    already_member = Membership.find_by user: current_user, beer_club_id: @membership.beer_club_id
    puts already_member
    if already_member
      already_in = current_user.beer_clubs.map {|club| club.name}
      @beer_clubs = BeerClub.where.not(name: already_in)
      @membership.errors.add(:base, "Already a member")
      render :new, status: :unprocessable_entity
    else
      if @membership.save
        redirect_to current_user
      else
        @beer_clubs = BeerClub.all
        render :new, status: :unprocessable_entity 
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    @membership.destroy!

    respond_to do |format|
      format.html { redirect_to memberships_path, status: :see_other, notice: "Membership was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.expect(membership: [ :user_id, :beer_club_id ])
    end
end
