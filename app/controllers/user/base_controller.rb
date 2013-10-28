class User::BaseController < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    if authorized?
    # ログインしているユーザーとリクエストしたorg_dirが一致しない場合は404を返す
      unless current_user.organization.directory == params[:org_dir]
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
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  helper_method :current_user

  def current_org
    @org ||= Organization.find_by(directory: params[:org_dir])
  end
  helper_method :current_org
end
