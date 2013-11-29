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
    # new, destroyでログインセッションを綺麗にする
    clear_login_session

    define = RegistrationService::Definitive.new(token: params[:token].to_s, host: request.host)
    if define.confirm
      # ログイン処理
      set_login_session define.confirmed_user

      redirect_to signup_confirmed_path
    else
      redirect_to signup_token_error_path
    end
  end

  # トークンエラー redirectする
  def signup_token_error
    # トークンが不正か、無効化されています。
    # 既存を参考にする
  end

  # /signup_confirmed 完了ページ
  def signup_confirmed
  end

  private
  def regist_params
    params.require(:registration_form).permit(:code, :number, :family_name, :first_name, :family_name_kana, :first_name_kana,
    :birthday, :login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation)
  end
end
