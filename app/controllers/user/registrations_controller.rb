# -*- coding: utf-8 -*-
#
class User::RegistrationsController < User::BaseController

  skip_before_action :authenticate_user!
  before_action :host_check!

  # /signup
  def new
    @regist_form = RegistrationForm.new
  end

  # /signup_process
  def create
    @regist_form = RegistrationForm.new(regist_params.merge(host: request.host))
    if @regist_form.submit
      redirect_to signup_provisional_path
    else
      render :new # 項目のエラー
    end
  end

  # /signup_provisional 仮登録完了ページ
  def signup_provisional
  end

  # /signup_token/:token 認証トークン確認ページ
  def signup_token
    # エラーの場合はrender :token_error
  end

  # トークンエラー
  def token_error
  end

  # /signup_confirmed 完了ページ
  def signup_confirmed
  end

  private
  def regist_params
    params.require(:registration_form).permit(:code, :number, :family_name_kana, :first_name_kana,
    :birthday, :login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation)
  end
end
