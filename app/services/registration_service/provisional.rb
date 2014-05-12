#
# ユーザー仮登録サービス
# Authors:: t-muta
# Date:: 2014-01-10
# LastUpdate:: 2014-01-10
#
#=== 履歴
#
#* 1 2014-01-10
#  * rdoc方式でコメントを追加
#

class RegistrationService::Provisional

  #
  # initialize, attributesメソッドが定義されている
  #
  include MultiParameterAttributes

  #
  # 仮登録に必要なパラメータ
  # 
  attr_accessor :email, :login_id, :password, :nickname

  #
  # 仮登録後に発行するtoken
  #
  attr_reader :signup_token

  #
  # 仮登録処理を行う
  #
  def regist
    ActiveRecord::Base.transaction do
      reset_provisional_user
      # 不要なtokenを無効化
      generate_provisional_user
      # 新しいtokenの作成
    end

    send_email # 仮登録メールを送信

    true
  end

  #
  # 仮登録メールを送信する
  #
  def send_email
    User::Registrations::ProvisionalMailer.provisional_mail(self.attributes).deliver
  end

  private

  #
  # トークン有効期限
  # TODO: DBや設定ファイルに切り出す
  #
  def extend_at
    7.days
  end

  #
  # トークンの生成
  #
  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while OnetimeToken.exists?(token: token)
    # 安全のためすべてのトークンと重複しないようにする
    token
  end

  #
  # 仮登録トークンの無効化
  # 引数
  #  organizationオブジェクト
  #  subscriber_informationオブジェクト
  #
  # 既に発行済みの仮登録トークンがある場合はすべて無効化する
  #
  def reset_provisional_user
    # 件数も多く無いと思われるのでeachでloopし個別にupdate
    ProvisionalUser.where(login_id: login_id).each do |prv_user|
      # 仮登録ユーザーの無効化
      prv_user.update(status: false)
      # 仮登録トークンの無効化
      prv_user.onetime_token.update(status: false)
    end
  end

  #
  # 仮登録トークンの発行
  # 引数
  #  organizationオブジェクト
  #  subscriber_informationオブジェクト
  #
  def generate_provisional_user
    @signup_token = generate_token

    # 仮登録ユーザーに紐づくワンタイムトークンを生成
    onetime_token = OnetimeToken.create(
      user_id: nil, # 仮登録時なのでnil
      status: true,
      token_type: "registration", # ユーザー登録のtoken_type
      token: @signup_token,
      expired_at: Time.now + extend_at
    )

    # 仮登録ユーザーの生成
    prov = org.provisional_users.create(
      onetime_token_id: onetime_token.id,
      status: true, # true: 仮登録受付, false: 仮登録完了
      email: email,
      login_id: login_id,
      password: password,
      password_confirmation: password,
      nickname: nickname
    )
  end
end
