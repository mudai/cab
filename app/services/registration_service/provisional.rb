class RegistrationService::Provisional
  attr_accessor :host, :code, :number, :family_name_kana, :first_name_kana,
    :birthday, :login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation
  def initialize(attributes = {}) # active modelをインクルードして取っ払う？
    attributes.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
  end

  def regist # 仮登録処理　関連するレコードを作る
    org = Organization.find_by(host: host)
=begin
    ActiveRecord::Base.transacton do
      prov = org.provisional_users.create(
        subscriber_information_id
        onetime_token_id
        status # true: 仮登録受付, false: 仮登録完了
        family_name # 名字
        first_name # 名前
        family_name_kana
        first_name_kana
        code # 記号
        number # 番号
        birthday # 生年月日
        email
        nickname
      )
    end
=end
    # 最後にbooleanを返る
    generate_token
    true
  end

  def signup_token
    @token
  end

  private

  def organization
  end

  def generate_token
    begin
      @token = SecureRandom.urlsafe_base64
    end while OnetimeToken.exists?(token: @token)
  end
end
