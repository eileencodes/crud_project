class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :social_accounts

  def prefix_options
    [['Mr.', 1], ['Mrs.', 2], ['Ms.', 3], ['Miss', 4]]
  end

  def full_name
    if self.first_name && self.last_name
      "#{self.first_name} #{self.last_name}"
    elsif self.first_name
      self.first_name
    elsif self.last_name
      self.last_name
    else
      "No Name"
    end
  end
end
