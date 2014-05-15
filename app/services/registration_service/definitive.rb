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
  include ActiveModel::Model

  #
  # 本登録に必要な仮登録トークンパラメータ
  #
  attr_accessor :token
  attr_reader :onetime_token, :confirmed_user

  validate :token_exists? # トークンが存在するかのチェック
  validate :token_expired? # トークンが有効状態にあるかのチェック
  validate :login_id_duplicate? # 取得しようとしているログインIDのチェック

  def token_exists?
    # トークンが見つからない場合は無効
    # 既に本登録済みの場合にもnilとなる
    if onetime_token.nil?
      # errors.messages.not_exist
      errors.add(:token, "トークンが存在しません。")
    end
  end

  def token_expired?
    # 有効期間外であれば無効
    if onetime_token && onetime_token.expired_at < Time.now
      # 有効期間外であればtokenが有効である必要がないのでstatus: falseに変更する
      # onetime_token.try(:update!, {status: false} )
      # errors.messages.expired
      errors.add(:token, "トークンは有効期限を過ぎています。")
    end
  end

  def login_id_duplicate?
    # tokenから仮登録ユーザーを引いて、userを作成する
    prov = onetime_token.provisional_user

    # 実際にユーザーテーブルにレコードを作成するタイミングで同じlogin_idのデータが存在した場合は再度仮登録から
    # やり直す必要がある
    if User.find_by(login_id: prov.login_id)
      # 既に重複するLoginIDがあるのであればtokenが有効である必要がないのでstatus: falseに変更する
      # onetime_token.try(:update!, {status: false} )
      # errors.messages.already_used
      errors.add(:login_id, "ログインIDは既に利用されています。")
    end
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
    @onetime_token = OnetimeToken.find_by(token: token, token_type: "registration", status: true)

    if @onetime_token.valid?
      ActiveRecord::Base.transaction do
        prov = onetime_token.provisional_user
        user = User.new do |u|
          u.login_id = prov.login_id
          u.password_digest = prov.password_digest
        end
        user.build_profile.nickname = prov.nickname
        user.save!(validate: false) # パスワードは暗号化させたままそのまま格納
        # ユーザーの作成が問題なければ他のtokenを無効化する
        onetime_token.update!(status: false)
        # 作成したユーザーをconfirmed_userにセット
        @confirmed_user = user
        # 登録完了メールの送信
        send_mail(prov.attributes)
      end
    end
  end

  #
  # 登録完了メールの送信
  #
  def send_mail(attrs)
    User::Registrations::DefinitiveMailer.definitive_mail(attrs.symbolize_keys).deliver
  end
end
