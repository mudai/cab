# -*- coding: utf-8 -*-
#
class RegistrationForm
  include ActiveModel::Model
  include MultiParameterAttributes # attributes=　が定義されている

  # TODO: バリデーション
  validates_with SubscriptionValidator # code, number, birthday, family_name_kana, first_name_kana これはこのバリデータに任せる
  validates :host, presence: true
  validates :login_id, presence: true# , uniqueness: {scope: :organization} # カスタムバリデータに変更する

  attr_accessor :host, :code, :number, :family_name, :first_name, :family_name_kana, :first_name_kana,
    :birthday, :email, :email_confirmation, :login_id, :password, :password_confirmation, :nickname
  form_multi_parameter :birthday, Date

  def initialize(params = {})
    self.attributes = params
  end

  # ログインボタンを押されたときの処理
  def submit
    provisional = RegistrationService::Provisional.new(attributes)

    if valid? && provisional.regist # パラメータのバリデーション＆権限チェックと仮登録レコードの作成
     
      token = provisional.signup_token # 登録が問題なければtokenが発行される
      User::Registrations::ProvisionalMailer.provisional_mail(
        attributes.merge(token: token)
      ).deliver

      true
    else # 入力チェックエラーの場合は一律のエラーメッセージをコントローラー側で出す
      false
    end
  end

  private

  def attributes
    Hash[instance_variable_names.map{|v| [v[1..-1].to_sym, instance_variable_get(v)]}]
  end
end
