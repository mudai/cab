# -*- coding: utf-8 -*-
#
class Admin::SessionsController < Admin::BaseController
  skip_before_action :authenticate_admin!, only: [:login, :login_process, :logout]
  before_action :org_dir_check!, only: :login

  def login
    clear_login_session # 既にログインしていた場合はログアウトさせる
    @auth_form = AuthenticationForm.new(current_org, request)
  end

  def login_process
    @auth_form = AuthenticationForm.new(current_org, request, login_params)
    if @auth_form.submit
      session[:user_id] = @auth_form.user.id
      cookies.signed[:secure_user_id] = {secure: true, value: "fly_secure_key_#{@auth_form.user.id}"}
      redirect_to session.delete(:return_to) || root_path, notice: "Logged in!"
    else
      flash.now.alert = "Login_id or Password is invalid"
      render :login
    end
  end

  def logout
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

  def org_dir_check! # URLが存在しない場合は404を返す
    unless org = Organization.find_by(directory: params[:org_dir])
      render_404
    end
  end
end
