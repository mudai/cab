class ProvisionalUser < ActiveRecord::Base
  belongs_to :organization
  belongs_to :subscriber_information
  belongs_to :onetime_token
end
