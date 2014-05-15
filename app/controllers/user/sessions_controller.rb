# -*- coding: utf-8 -*-
#
# ログイン/ログアウト用のコントローラー
# Authors:: t-muta
# Date:: 2014-01-10
# LastUpdate:: 2014-01-10
#
#=== 履歴
#
#* 1 2014-01-10
#  * rdoc方式でコメントを追加
#

class User::SessionsController < User::BaseController

  # 認証処理をスキップ
  skip_before_action :authenticate_user!, only: [:new, :create, :destroy]

  # ログイン済みの場合もあるのでセッションをクリア
  before_action :clear_login_session, only: [:new, :destroy]

  # ログインページ
  def new
    @auth_form = AuthenticationForm.new
  end

  # ログイン処理
  def create
    @auth_form = AuthenticationForm.new(login_params)
    if @auth_form.submit
      # ログイン処理
      set_login_session @auth_form.user
      redirect_to session.delete(:return_to) || root_path, notice: "Logged in!"
    else
      flash.now.alert = "Login_id or Password is invalid"
      render :new
    end
  end

  # ログアウト処理
  def destroy
    redirect_to login_path, notice: "Logout Success"
  end

  private
  def login_params
    params.require(:authentication_form).permit(:login_id, :password)
  end
end
