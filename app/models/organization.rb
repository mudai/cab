class Organization < ActiveRecord::Base
  has_many :users
  has_many :login_histories
  has_many :login_id_histories
  has_many :password_histories
end
