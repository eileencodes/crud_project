module SampleDataDelete
  # DO NOT run with large data sets (100k or more) unless you are ok
  # with killing your MySQL instance
  def self.destroy_contacts_oh_crud(category)
    category.contacts.destroy_all
  end

  def self.delete_contacts_oh_crud(category)
    category.contacts.delete_all
  end

  # although category.categorizations.delete_all is valid
  # I prefer this way, faster and more reliable.
  def self.delete_categorizations_optimized(category)
    Categorization.where(:category_id => cat.id).delete_all
  end

  def self.delete_contacts_optimized(category)
    Contact.joins(:categorizations).where('categorizations.category_id' => cat.id).delete_all
  end
end
