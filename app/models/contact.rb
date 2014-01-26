class Contact < ActiveRecord::Base
  belongs_to :contacts
  has_many :social_accounts
end
