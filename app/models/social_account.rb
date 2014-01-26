class SocialAccount < ActiveRecord::Base
  belongs_to :contacts
  has_many :social_account_types
end
