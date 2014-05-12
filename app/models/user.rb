class User < ActiveRecord::Base

  has_many :login_histories
  has_many :login_id_histories
  has_many :password_histories
  has_one :profile

  validates :login_id, presence: true, uniqueness: true
  validates :password, confirmation: true

  has_secure_password
end
