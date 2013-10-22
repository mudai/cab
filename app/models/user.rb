class User < ActiveRecord::Base

  belongs_to :organization
  has_many :login_histories
  has_many :login_id_histories
  has_many :password_histories

  validates_presence_of :login_id
  validates_uniqueness_of :login_id # TODO: scope
  validates_confirmation_of :password

  has_secure_password
end
