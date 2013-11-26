class User < ActiveRecord::Base

  belongs_to :organization
  has_many :login_histories
  has_many :login_id_histories
  has_many :password_histories
  has_one :profile
  has_one :subscriber_information

  validates :login_id, presence: true
  validates :login_id, uniqueness: {:scope => :organization_id}
  validates :password, confirmation: true

  has_secure_password
end
