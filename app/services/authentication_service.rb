class AuthenticationService
  # 認証処理を担うクラス
  def initialize(org_dir, login_id, password)
    @org_dir, @login_id, @password = org_dir, login_id, password
  end

  # 認証が可能なユーザーを取得
  def user
    @user ||= user_with_password
  end

  # 認証可能かどうかを判断
  def authenticate?
    user.present?
  end

  # ログインログをとる
  def authenticate_logging!(request)
    # 認証後のログインログ書き込み処理を入れる
    user.login_histories.create!(
      organization_id: user.organization_id,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      logged_in_at: Time.now
    )
  end

  private

  def user_with_password
    user = User.find_by(login_id: @login_id)
    user && user.authenticate(@password) # user.rbモデルにhas_secure_passwordをつけておく
  end
end
