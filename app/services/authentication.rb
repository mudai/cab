class AuthenticationService
  def initialize(org_dir, login_id, password)
    @org_dir, @login_id, @password = login_id, password, org_dir
  end

  def user
    @user ||= user_with_password
  end

  # 認証する
  def authenticate?
    user.present?
  end

  private

  def user_with_password
    user = User.find_by(login_id: @login_id)
    user && user.authenticate(@password) # user.rbモデルにhas_secure_passwordをつけておく
  end
end
