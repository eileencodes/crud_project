module SampleDataUpdate
  def self.update_contacts_oh_crud(category)
    Categorization.all.each do |categorization|
      categorization.update_attributes(:category_id => category.id)
    end
  end

  def self.update_contacts_optimized(category)
    Categorization.update_all(:category_id => category.id)
  end
end
