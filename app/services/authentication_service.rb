class AuthenticationService
  # 認証処理を担うクラス
  def initialize(host, login_id, password)
    @host, @login_id, @password = host, login_id, password
  end

  # 認証が可能なユーザーを取得
  def user
    @user ||= user_with_password
  end

  # 認証可能かどうかを判断
  def authenticate?
    user.present?
  end



  class << self
    # 認証処理の後に行うコールバック
    def after_authenticate!(user, request)
      now = Time.now
      user.first_logged_in_at ||= now # 初回ログイン日時
      user.last_logged_in_at = now # 最終ログイン日時の更新
      ActiveRecord::Base.transaction do
        user.save!
        authenticate_logging!(user, now, request)
      end
    end
    # ログインログをとる
    # オブジェクトに依存しないclassメソッドにする
    def authenticate_logging!(user, now, request)
      # 認証後のログインログ書き込み処理を入れる
      user.login_histories.create!(
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        logged_in_at: now
      )
    end
  end

  private

  def user_with_password
    if org = Organization.find_by(host: @host)
      user = org.users.find_by(login_id: @login_id)
      user && user.authenticate(@password) # user.rbモデルにhas_secure_passwordをつけておく
    end
  end
end
