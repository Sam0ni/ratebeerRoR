class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: %i[index show new create]
  before_action :ensure_that_admin, only: %i[destroy toggle_closed]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if current_user == @user
      respond_to do |format|
        if user_params[:username].nil? && (@user == current_user) && @user.update(user_params)
          format.html { redirect_to @user, notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      render :show, status: :unauthorized, location: @user
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if current_user == @user
      @user.destroy!
      session[:user_id] = nil

      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      render :show, status: :unauthorized, location: @user
    end
  end

  def toggle_closed
    user = User.find(params[:id])
    user.update_attribute :closed, !user.closed

    new_status = user.closed? ? "closed" : "active"

    redirect_to user, notice: "account status changed to #{new_status}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
