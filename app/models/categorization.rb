class Categorization < ActiveRecord::Base
  belongs_to :contact
  belongs_to :category
end
