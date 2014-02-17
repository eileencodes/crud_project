module SampleDataRead

  def self.read_contacts_oh_crud
    Contact.where(:user_id => 1, :country => "USA").each do |contact|
      puts contact.first_name
    end
  end

  def self.read_contacts_optimized
    Contact.where(:user_id => 1, :country => "USA").find_each do |contact|
      puts contact.first_name
    end
  end

  def self.read_contacts_optimized_alt
    Contact.where(:user_id => 1, :country => "USA").select(:first_name).each do |contact|
      puts contact.first_name
    end
  end
end
