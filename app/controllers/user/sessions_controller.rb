# -*- coding: utf-8 -*-
#
class User::SessionsController < User::BaseController
  def login
    session[:return_to] = params[:return_to] if params[:return_to]
    @auth_form = AuthenticationForm.new
  end

  def login_process
    @auth_form = AuthenticationForm.new(login_params)
    if @auth_form.submit
      session[:user_id] = @auth_form.user.id
      cookies.signed[:secure_user_id] = {secure: true, value: "fly_secure_key_#{user.id}"}
      redirect_to(session.delete[:return_to] || root_path), notice: "Logged in!"
    else
      flash.now.alert = "Login_id or Password is invalid"
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    cookies.delete[:secure_user_id] = nil
    redirect_to login_path, notice: "Logout Success"
  end

  private
  def login_params
    params.require(:authentication_form).permit(:login_id, :password)
  end
end
