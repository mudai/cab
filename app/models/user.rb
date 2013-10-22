class User < ActiveRecord::Base

  validates_presence_of :login_id, :email
  validates_uniqueness_of :login_id
  validates_confirmation_of :password

  has_secure_password
end
