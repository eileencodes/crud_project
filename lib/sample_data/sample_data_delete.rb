module SampleDataDelete
  # DO NOT run with large data sets (10k or more) unless you are ok
  # with killing your MySQL instance
  def self.delete_contacts_oh_crud(category)
    cat.categorizations.destroy_all
  end

  def self.delete_contacts_oh_crud_alt(category)
    cat.categorizations.delete_all
  end

  def self.delete_contacts_optimized(category)
    Categorization.where(:category_id => cat.id).delete_all
  end
end
