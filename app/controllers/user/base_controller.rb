#
# エンドユーザー側のコントローラ基本処理
# Authors:: t-muta
# Date:: 2014-01-10
# LastUpdate:: 2014-01-10
#
#=== 履歴
#
#* 1 2014-01-10
#  * rdoc方式でコメントを追加
#

class User::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  #
  # ユーザーが認証済みか確認
  #
  def authenticate_user!
    if authorized?
      # request.hostが変わるとcookieやセッションが変わるはずなので
      # 基本くることは無い
      unless current_user.organization.host == request.host
        render_404
      end
    else
      # 認証されていない場合 -> login_pathへリダイレクト
      if valid_host?
        # リクエストされたhostが団体に存在する場合、セッションをクリアしlogin_pathへリダイレクト
        store_location
        redirect_to login_path
      else
        # 存在しない場合は404を返す
        render_404
      end
    end

  end

  #
  # リクエストされたhostが団体に存在しない場合は404を返す
  # TODO: このコード自体が不要？再度検討すること
  #
  def host_check!
    render_404 unless valid_host?
  end

  #
  # リクエストされたhostが団体に存在するかを判断
  #
  def valid_host?
    Organization.exists?(host: request.host)
  end

  #
  # ユーザーが認証済みかを判断
  #
  def authorized?
    current_user.present?
  end

  # リクエストされたURLをセッションに格納
  #  ログイン後にリダイレクトするために利用
  def store_location
    session[:return_to] = request.url
  end

  #
  # 現在ログインしているユーザーを取得
  #  ログインしていない場合はnilを返す
  #
  def current_user
    if !request.ssl? || cookies.signed[:secure_user_id] == "fly_secure_key_#{session[:user_id]}"
      @current_user ||= User.includes(:organization).find(session[:user_id]) if session[:user_id]
    end
  end
  helper_method :current_user

  #
  # 現在リクエストされている団体を返す
  #
  def current_org
    @org ||= Organization.find_by(host: request.host)
  end
  helper_method :current_org

  #
  # ログイン処理を行う
  #  管理画面からログインする場合はauthentication_callback: falseする
  #
  def set_login_session(user, authentication_callback: true)
    session[:user_id] = user.id 
    cookies.signed[:secure_user_id] = {secure: true, value: "secure_key_#{user.id}"}
    if authentication_callback
      # タイムスタンプ更新
      AuthenticationService.after_authenticate!(user, request)
    end
  end

  #
  # ログアウト処理を行う
  #
  def clear_login_session
    # new, destroyでログインセッションを綺麗にする
    session[:user_id] = nil
    cookies.delete(:secure_user_id)
  end
end
