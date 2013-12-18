# -*- coding: utf-8 -*-
#
class RegistrationForm
  include ActiveModel::Model
  include MultiParameterAttributes # attributes=　が定義されている

  # TODO: バリデーション
  validates_with SubscriptionValidator # code, number, birthday, family_name_kana, first_name_kana これはこのバリデータに任せる
  validates :host, presence: true
  validates :login_id, presence: true, length: {minimum: 4, maximum: 255}
  validate :login_id_unique_validater
  validates :password, presence: true, length: {minimum: 4, maximum: 255}, confirmation: true
  validates :nickname, presence: true, length: {minimum: 1, maximum: 255}
  validates :email, presence: true, length: { maximum: 255 }, confirmation: true, email: true

  attr_accessor :host, :code, :number, :family_name, :first_name, :family_name_kana, :first_name_kana,
    :birthday, :email, :email_confirmation, :login_id, :password, :password_confirmation, :nickname
  form_multi_parameter :birthday, Date

  # ログインボタンを押されたときの処理
  def submit
    provisional = RegistrationService::Provisional.new(self.attributes)

    valid? && provisional.regist # パラメータのバリデーション＆権限チェックと仮登録レコードの作成とメールの送信
  end

  private
  def login_id_unique_validater
    # login_idのユニークチェック
    # 全体でユニークでよいと思う。そのうち考える
    if User.find_by(login_id: self.login_id) # TODO: MySQLにしてexists?メソッドが使えたらそちらを利用する
      message = I18n.t('activerecord.errors.messages.already_used')
      errors.add(:login_id, message)
    end
  end
end
