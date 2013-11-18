class RegistrationService::Provisional
  attr_accessor :host, :code, :number, :family_name_kana, :first_name_kana,
    :birthday, :email
  def initialize(attributes = {}) # active modelをインクルードして取っ払う？
    attributes.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
  end

  def regist # 仮登録処理　関連するレコードを作る
    org = Organization.find_by(host: host)
=begin
    ActiveRecord::Base.transacton do
      # TODO: tokenの作成
      onetime_token = org.onetime_tokens.create(
        user_id: nil, # 仮登録時なのでnil
        status: true,
        token_type: "registration",
        token: generate_token,
        expired_at: Time.now + extend_at
      )

      prov = org.provisional_users.create(
        subscriber_information_id: subscription.id,
        onetime_token_id: onetime_token.id,
        status: true, # true: 仮登録受付, false: 仮登録完了
        family_name: family_name, # 名字
        first_name: first_name, # 名前
        family_name_kana: family_name_kana,
        first_name_kana: first_name_kana,
        code: code, # 記号
        number: number, # 番号
        birthday: birthday, # 生年月日
        email: email
      )
      # 他の仮登録トークンは終了する
    end
=end
    # 最後にbooleanを返る
    generate_token
    true
  end

  def extend_at
    # DBに格納する？
    7.days
  end

  def subscription
    org = organization

    subscriptions = org.subscriber_informations.where(code: code, number: number, birthday: birthday)

    subscriptions.to_a.find do |x|
      convert_kana(x.family_name_kana) == convert_kana(family_name_kana) &&
        convert_kana(x.first_name_kana) == convert_kana(first_name_kana)
    end
  end

  def signup_token
    @token
  end

  private

  def organization
    Organization.find_by(host: host)
  end

  def generate_token
    begin
      @token = SecureRandom.urlsafe_base64
    end while OnetimeToken.exists?(token: @token)
    @token
  end
end
