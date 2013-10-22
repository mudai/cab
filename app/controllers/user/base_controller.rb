class User::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
  end

  def current_user
    if !request.ssl? || cookies.signed[:secure_user_id] == "fly_secure_key_#{session[:user_id]}"
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  helper_method :current_user
end
