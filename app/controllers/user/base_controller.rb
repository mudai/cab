class User::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless authorized?
      store_location
      redirect_to login_path
    end
  end

  def authorized?
    current_user.present?
  end

  def store_location
    session[:return_to] = request.url
  end

  def current_user
    if !request.ssl? || cookies.signed[:secure_user_id] == "fly_secure_key_#{session[:user_id]}"
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  helper_method :current_user

  def current_org
    @org ||= Organization.find_by(directory: params[:org_dir])
  end
  helper_method :current_org
end
