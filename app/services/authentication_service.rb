#
# 認証処理サービス
# Authors:: t-muta
# Date:: 2014-01-10
# LastUpdate:: 2014-01-10
#
#=== 履歴
#
#* 1 2014-01-10
#  * rdoc方式でコメントを追加
#

class AuthenticationService

  #
  # 認証するlogin_id, passwordを与える
  #
  def initialize(login_id, password)
    @login_id, @password = login_id, password
  end

  #
  # login_id, passwordが一致した認証可能なユーザーを取得
  #
  def user
    @user ||= user_with_password
  end

  #
  # 認証可能か判断
  # (認証可能なユーザーが存在するかで判断)
  #
  def authenticate?
    user.present?
  end

  class << self

    #
    # 認証処理の後に行うコールバック
    # 引数
    #  userオブジェクト, requestオブジェクト
    #
    # 効果
    #  ログインログを格納
    #
    # TODO: 非同期化
    #
    def after_authenticate!(user, request)
      now = Time.now
      user.first_logged_in_at ||= now # 初回ログイン日時
      user.last_logged_in_at = now # 最終ログイン日時の更新
      ActiveRecord::Base.transaction do
        user.save!
        authenticate_logging!(user, now, request)
        # ログイン後に行いたい処理がある場合は、ここにメソッドを追記
      end
    end

    #
    # ログインログを格納
    #
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

  #
  # ユーザーのパスワードと渡されたパスワードを比較し、一致するならばuserオブジェクトを返す
  # 一致しないか見つからない場合はnilを返す
  #
  def user_with_password
    user = User.find_by(login_id: @login_id)
    user && user.authenticate(@password) # user.rbモデルにhas_secure_passwordをつけておく
  end
end
