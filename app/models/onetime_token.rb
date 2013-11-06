class OnetimeToken < ActiveRecord::Base
  belongs_to :organization
  has_one :provisional_user
end
