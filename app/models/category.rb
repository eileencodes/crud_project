class Category < ActiveRecord::Base
  belongs_to :user
  has_many :categorizations, dependent: :delete_all
  has_many :contacts, through: :categorizations
end
