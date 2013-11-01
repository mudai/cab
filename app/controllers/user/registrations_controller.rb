# -*- coding: utf-8 -*-
#
class User::RegistrationsController < User::BaseController

  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :host_check!, only: [:new, :create]

  # /signup
  def new
    @regst_form = RegistrationForm.new(request)
  end

  # /signup_process
  def create
    @regist_form = RegistrationForm.new(request, login_params)
    if @regist_form.submit
      session[:user_id] = @auth_form.user.id
      cookies.signed[:secure_user_id] = {secure: true, value: "fly_secure_key_#{@auth_form.user.id}"}
      redirect_to session.delete(:return_to) || root_path, notice: "Logged in!"
    else
      flash.now.alert = "Login_id or Password is invalid"
      render :new
    end
  end

  # /provisional_signup 仮登録完了ページ
  def provisional_signup
  end

  private
  def regist_params
    params.require(:registration_form).permit(:login_id, :password, :password_confirmation, :email, :nickname)
  end
end
