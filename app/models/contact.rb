class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :social_accounts

  def prefix_options
    [['Mr.', 1], ['Mrs.', 2], ['Ms.', 3], ['Miss', 4]]
  end
end
