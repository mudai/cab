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
    @regist_form = RegistrationForm.new(regist_params)
    if @regist_form.submit
      redirect_to signup_provisional_path
    else
      render :new # 項目のエラー
    end
  end

  # /signup_provisional 仮登録完了ページ
  def signup_provisional
    # 直接GETできないように考慮する
  end

  # /signup_token/:token 認証トークン確認ページ
  def signup_token
    # new, destroyでログインセッションを綺麗にする
    clear_login_session

    @define = RegistrationService::Definitive.new(token: params[:token].to_s)
    if @define.confirm && @define.error == RegistrationService::Definitive::Error::NOTHING
      # ログイン処理
      set_login_session @define.confirmed_user

      redirect_to signup_confirmed_path
    else
      render :signup_error
    end
  end

  # トークンエラー redirectする
  def signup_error
    # トークンが不正か、無効化されています。
    # 既存を参考にする
  end

  # /signup_confirmed 完了ページ
  def signup_confirmed
  end

  private
  def regist_params
    params.require(:registration_form).permit(:login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation)
  end
end
