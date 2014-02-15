module SampleDataRead

  def self.read_contacts_oh_crud
    Contact.where(:user_id => 1).each do |contact|
      puts contact.first_name
    end
  end

  def self.read_contacts_optimized
    Contact.where(:user_id => 1).find_each do |contact|
      puts contact.first_name
    end
  end

  def self.read_contacts_alt
    Contact.select(:first_name).each do |contact|
      puts contact.first_name
    end
  end
end
