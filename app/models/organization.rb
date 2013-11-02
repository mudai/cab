class Organization < ActiveRecord::Base
  has_many :users
  has_many :login_histories
  has_many :login_id_histories
  has_many :password_histories 
  has_many :mail_templates
  has_many :subscriber_informations

  # hostにはユニーク制約をつける
end
