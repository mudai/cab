class RegistrationService::Provisional
  attr_accessor :host, :code, :number, :family_name_kana, :first_name_kana,
    :birthday, :login_id, :password, :password_confirmation, :nickname, :email, :email_confirmation
  def initialize(attributes = {})
    attributes.try(:each) do |name, value|
      send("#{name}=", value) rescue nil
    end
  end

  def regist # 仮登録処理　関連するレコードを作る
    # 最後にbooleanを返る
    true
  end

  def signup_token
    "token_test"
  end

  private
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
