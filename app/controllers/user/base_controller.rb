class User::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    if authorized?
      # ホストが変わるとcookieやセッションが変わるはずなので
      unless current_user.organization.host == request.host # 基本くることは無いが一応エラーハンドリング
        render_404
      end
    else # 認証されていない場合　ログインページへリダイレクト
      if valid_host? # 対象のページが存在する場合はセッションをクリアしログインページへリダイレクト
        store_location
        redirect_to login_path
      else # 存在しない場合は404を返す
        render_404
      end
    end

  end

  def host_check! # URLが存在しない場合は404を返す TODO: このコード自体がいらないかもしれない
    render_404 unless valid_host?
  end

  def valid_host?
    Organization.exists?(host: request.host)
  end

  def authorized?
    current_user.present?
  end

  def store_location
    session[:return_to] = request.url
  end

  def current_user
    if !request.ssl? || cookies.signed[:secure_user_id] == "fly_secure_key_#{session[:user_id]}"
      @current_user ||= User.includes(:organization).find(session[:user_id]) if session[:user_id]
    end
  end
  helper_method :current_user

  def current_org
    @org ||= Organization.find_by(host: request.host)
  end
  helper_method :current_org

  def set_login_session(user)
    session[:user_id] = user.id 
    cookies.signed[:secure_user_id] = {secure: true, value: "fly_secure_key_#{user.id}"}
  end

  def clear_login_session
    # new, destroyでログインセッションを綺麗にする
    session[:user_id] = nil
    cookies.delete(:secure_user_id)
  end
end
