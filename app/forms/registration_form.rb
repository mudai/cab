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

  # ログインボタンを押されたときの処理
  def submit
    provisional = RegistrationService::Provisional.new(self.attributes)

    valid? && provisional.regist # パラメータのバリデーション＆権限チェックと仮登録レコードの作成とメールの送信
  end
end
