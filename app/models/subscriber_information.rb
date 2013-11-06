class SubscriberInformation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_many :provisional_users
end
