class ProvisionalUser < ActiveRecord::Base
  belongs_to :onetime_token

  has_secure_password
end
