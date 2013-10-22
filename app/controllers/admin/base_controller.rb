class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    if authorized?
    # ログインしているユーザーとリクエストしたorg_dirが一致しない場合は404を返す
      unless current_admin.organization.directory == params[:org_dir]
        render_404
      end
    else # 認証されていない場合　ログインページへリダイレクト
      store_location
      redirect_to admin_login_path
    end

  end

  def authorized?
    current_admin.present?
  end

  def store_location
    session[:return_to] = request.url
  end

  def current_admin
    if !request.ssl? || cookies.signed[:secure_admin_user_id] == "fly_secure_key_#{session[:admin_id]}"
      @current_admin ||= Administrator.find(session[:admin_id]) if session[:admin_id]
    end
  end
  helper_method :current_admin

  def current_org
    @org ||= Organization.find_by(directory: params[:org_dir])
  end
  helper_method :current_org
end
