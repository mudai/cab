class RegistrationService::Definitive
  # 本登録時に別セッションで二重登録ができないようにする
  attr_accessor :host, :token

  # includeして外す
  def initialize(attributes = {}) # TODO: active modelをインクルードして取っ払う？
    attributes.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
  end

  def confirm
    org = Organization.find_by(host: host)
    onetime_token = org.onetime_tokens.find_by(token: token, token_type: "registration", status: true)

    if onetime_token && onetime_token.expired_at >= Time.now # 有効期間内

      # tokenから仮登録ユーザーを引いて、userを作成する
      prov = onetime_token.provisional_user

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

      true
    else # 有効期間外か見つからない
      # 有効期間外であればtokenが有効である必要がないのでstatus: falseに変更する
      onetime_token.try(:update!, {status: false} )
      false
    end
  end

  def send_mail(attrs)
    User::Registrations::DefinitiveMailer.definitive_mail(attrs.symbolize_keys).deliver
  end

  # confirmを押下して問題なければ対象ユーザーが取得できる
  def confirmed_user
    @confirmed_user
  end

end
