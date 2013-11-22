# -*- coding: utf-8 -*-
#
class User::SessionsController < User::BaseController

  skip_before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :host_check!, only: [:new, :create, :destroy]
  before_action :clear_login_session, only: [:new, :destroy]

  def new
    @auth_form = AuthenticationForm.new(request)
  end

  def create
    @auth_form = AuthenticationForm.new(request, login_params)
    if @auth_form.submit
      set_login_session @auth_form.user
      redirect_to session.delete(:return_to) || root_path, notice: "Logged in!"
    else
      flash.now.alert = "Login_id or Password is invalid"
      render :new
    end
  end

  def destroy
    redirect_to login_path, notice: "Logout Success"
  end

  private
  def login_params
    params.require(:authentication_form).permit(:login_id, :password)
  end
end
