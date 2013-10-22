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

  # ログイン後の処理
  def after_authenticate!
    # 認証後のログ書き込み処理を入れる
  end

  private

  def user_with_password
    user = User.find_by(login_id: @login_id)
    user && user.authenticate(@password) # user.rbモデルにhas_secure_passwordをつけておく
  end
end
