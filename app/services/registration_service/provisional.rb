class RegistrationService::Provisional
  include MultiParameterAttributes

  attr_accessor :host, :code, :number, :family_name, :first_name, :family_name_kana, :first_name_kana,
    :birthday, :email, :login_id, :password, :nickname
  attr_reader :signup_token


  def regist # 仮登録処理　関連するレコードを作る
    org = Organization.find_by(host: host)
    info = org.subscriber_informations.search(
      code: code,
      number: number,
      birthday: birthday,
      family_name_kana: family_name_kana,
      first_name_kana: first_name_kana 
    )

    ActiveRecord::Base.transaction do
      reset_provisional_user(org, info) # 他のtokenを無効化
      generate_provisional_user(org, info) # 新しいtokenの作成
    end

    send_email

    true
  end

  # 仮登録メールを送信する
  def send_email
    User::Registrations::ProvisionalMailer.provisional_mail(self.attributes).deliver
  end

  private

  def extend_at
    # DBに格納する？ TODO: 
    7.days
  end

  def generate_token
    begin
      token = SecureRandom.urlsafe_base64
    end while OnetimeToken.exists?(token: token) # 安全のためすべてのトークンとかぶらないようにする
    token
  end

  # 既にトークン発行済の場合は無効化する
  def reset_provisional_user(org, info)
    # 仮登録データの無効化
    # 仮登録データにひもづくtokenの無効化
    # 対した件数も無いと思われるのでloopにした
    org.provisional_users.where(subscriber_information_id: info.id).each do |prv_user|
      prv_user.update(status: false)
      prv_user.onetime_token.update(status: false)
    end
  end

  # トークンとprovisional_user(仮登録ユーザー)を発行する
  def generate_provisional_user(org, info)
    # TODO: tokenの作成
    @signup_token = generate_token
    onetime_token = org.onetime_tokens.create(
      user_id: nil, # 仮登録時なのでnil
      status: true,
      token_type: "registration", # ユーザー登録のtoken_type
      token: @signup_token,
      expired_at: Time.now + extend_at
    )

    prov = org.provisional_users.create(
      subscriber_information_id: info.id,
      onetime_token_id: onetime_token.id,
      status: true, # true: 仮登録受付, false: 仮登録完了
      family_name: family_name, # 名字
      first_name: first_name, # 名前
      family_name_kana: family_name_kana,
      first_name_kana: first_name_kana,
      code: code, # 記号
      number: number, # 番号
      birthday: birthday, # 生年月日
      email: email,
      login_id: login_id,
      password: password,
      password_confirmation: password,
      nickname: nickname
    )
  end
end
