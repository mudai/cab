#
# ユーザー本登録サービス
# Authors:: t-muta
# Date:: 2014-01-10
# LastUpdate:: 2014-01-10
#
#=== 履歴
#
#* 1 2014-01-10
#  * rdoc方式でコメントを追加
#

class RegistrationService::Definitive

  #
  # 本登録に必要なhostと仮登録トークンパラメータ
  #
  attr_accessor :host, :token

  #
  # 本登録時に発生しうるエラーのタイプ
  #
  module Error
    NOTHING = "nothing"               # 問題なし
    LOGIN_ID_EXIST = "login_id_exist" # ログインIDが重複した場合
    TOKEN_EXPIRED = "token_expired"   # トークンの有効期限が切れた場合
  end

  # includeして外す
  def initialize(attributes = {}) # TODO: active modelをインクルードして取っ払う？
    attributes.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
  end

  #
  # 本登録処理をおこなう
  #
  def confirm
    org = Organization.find_by(host: host)
    onetime_token = org.onetime_tokens.find_by(token: token, token_type: "registration", status: true)

    # 有効期間外であれば無効
    if onetime_token && onetime_token.expired_at < Time.now
      # 有効期間外であればtokenが有効である必要がないのでstatus: falseに変更する
      onetime_token.try(:update!, {status: false} )
      @error = Error::TOKEN_EXPIRED
      return false
    end

    # tokenから仮登録ユーザーを引いて、userを作成する
    prov = onetime_token.provisional_user

    # 実際にユーザーテーブルにレコードを作成するタイミングで同じlogin_idのデータが存在した場合は再度仮登録から
    # やり直す必要がある
    if org.users.find_by(login_id: prov.login_id)
      # 既に重複するLoginIDがあるのであればtokenが有効である必要がないのでstatus: falseに変更する
      onetime_token.try(:update!, {status: false} )
      @error = Error::LOGIN_ID_EXIST
      return false
    end

    ActiveRecord::Base.transaction do
      user = org.users.new do |u|
        u.login_id = prov.login_id
        u.password_digest = prov.password_digest
      end
      user.build_profile.nickname = prov.nickname
      user.save!(validate: false) # パスワードは暗号化させたままそのまま格納
      # subscriber_informationのassociated_atとuser_idを更新する
      subscriber = prov.subscriber_information
      subscriber.update!(user_id: user.id, associated_at: Time.now)
      # ユーザーの作成が問題なければ他のtokenを無効化する
      onetime_token.update!(status: false)
      # 作成したユーザーをconfirmed_userにセット
      @confirmed_user = user
    end

    # 登録完了メールの送信
    send_mail(prov.attributes.merge(host: host))

    @error = Error::NOTHING
    true
  end

  #
  # 登録完了メールの送信
  #
  def send_mail(attrs)
    User::Registrations::DefinitiveMailer.definitive_mail(attrs.symbolize_keys).deliver
  end

  #
  # 本登録済みユーザーの取得
  #  confirmメソッドを呼び出し、問題なく登録できたユーザーが取得できる
  #
  def confirmed_user
    @confirmed_user
  end

  #
  # エラー発生時にエラータイプが入る
  # NOTHING = "nothing"               # 問題なし
  # LOGIN_ID_EXIST = "login_id_exist" # ログインIDが重複した場合
  # TOKEN_EXPIRED = "token_expired"   # トークンの有効期限が切れた場合
  #
  def error
    @error
  end

end
