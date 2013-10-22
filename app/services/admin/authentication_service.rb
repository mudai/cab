class Admin::AuthenticationService
  # 管理画面の認証処理を担うクラス
  def initialize(org, login_id, password)
    @org, @login_id, @password = org, login_id, password
  end

  # 認証が可能なユーザーを取得
  def admin
    @admin ||= admin_with_password
  end

  # 認証可能かどうかを判断
  def authenticate?
    admin.present?
  end

  # 認証処理の後に行うコールバック
  def after_authenticate!(request)
    now = Time.now
    user.first_logged_in_at ||= now # 初回ログイン日時
    user.last_logged_in_at = now # 最終ログイン日時の更新
    ActiveRecord::Base.transaction do
      user.save!
      authenticate_logging!(now, request)
    end
  end

  # ログインログをとる
  def authenticate_logging!(now, request)
    # 認証後のログインログ書き込み処理を入れる
    user.login_histories.create!(
      organization_id: user.organization_id,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      logged_in_at: now
    )
  end

  private

  def user_with_password
    return if @org.nil? # 存在しないdirectoryのチェック
    user = @org.users.find_by(login_id: @login_id)
    user && user.authenticate(@password) # user.rbモデルにhas_secure_passwordをつけておく
  end
end
