# -*- coding: utf-8 -*-
#
class User::SessionsController < User::BaseController

  skip_before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :host_check!, only: [:new, :create, :destroy]

  def new
    redirect_to root_path, notice: "already logged" if authorized?
    clear_login_session # ゴミセッションをクリア
    @auth_form = AuthenticationForm.new(request)
  end

  def create
    @auth_form = AuthenticationForm.new(request, login_params)
    if @auth_form.submit
      session[:user_id] = @auth_form.user.id
      cookies.signed[:secure_user_id] = {secure: true, value: "fly_secure_key_#{@auth_form.user.id}"}
      redirect_to session.delete(:return_to) || root_path, notice: "Logged in!"
    else
      flash.now.alert = "Login_id or Password is invalid"
      render :login
    end
  end

  def destroy
    clear_login_session
    redirect_to login_path, notice: "Logout Success"
  end

  private
  def login_params
    params.require(:authentication_form).permit(:login_id, :password)
  end

  def clear_login_session
    session[:user_id] = nil
    cookies.delete(:secure_user_id)
  end

  def host_check! # URLが存在しない場合は404を返す TODO: このコード自体がいらないかもしれない
    render_404 unless valid_host?
  end
end
