class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user
  helper_method :latest_search

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def latest_search
    return nil if session[:last_search].nil?

    session[:last_search]
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end
end
