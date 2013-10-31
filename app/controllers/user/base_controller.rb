class User::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    if authorized?
      unless current_user.organization.host == request.host # 基本くることは無いが一応エラーハンドリング
        render_404
      end
    else # 認証されていない場合　ログインページへリダイレクト
      if current_org.present? # 対象のページが存在する場合はセッションをクリアしログインページへリダイレクト
        store_location
        redirect_to login_path
      else # 存在しない場合は404を返す
        render_404
      end
    end

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
end
