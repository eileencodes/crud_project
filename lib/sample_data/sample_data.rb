require 'faker'
require 'csv'

module SampleData
  def self.create_contacts_oh_crud
    CSV.foreach("#{Rails.root}/lib/sample_data/contacts.csv", headers: true) do |csv|
      Contact.create!({
        :first_name => csv[0],
        :last_name => csv[1],
        :birthday => csv[2],
        :phone => csv[3],
        :email => csv[4],
        :twitter_account_link => csv[5],
        :facebook_account_link => csv[6],
        :linkedin_account_link => csv[7],
        :gplus_account_link => csv[8],
        :github_account_link => csv[9],
        :address_1 => csv[10],
        :address_2 => csv[11],
        :city => csv[12],
        :state => csv[13],
        :postal_code => csv[14],
        :country => csv[15],
        :company => csv[16],
        :title => csv[17],
        :company_address_1 => csv[18],
        :company_address_2 => csv[19],
        :company_city => csv[20],
        :company_state => csv[21],
        :company_postal_code => csv[22],
        :company_country => csv[23],
        :user_id => csv[24]
      })
    end
  end

  def self.create_contacts
    contact_values = []
    CSV.foreach("#{Rails.root}/lib/sample_data/contacts.csv", headers: true) do |csv|
      contact_values << "('#{csv[0]}','#{csv[1]}','#{csv[2]}','#{csv[3]}','#{csv[4]}','#{csv[5]}','#{csv[6]}','#{csv[7]}','#{csv[8]}','#{csv[9]}','#{csv[10]}','#{csv[11]}','#{csv[12]}','#{csv[13]}','#{csv[14]}','#{csv[15]}','#{csv[16]}','#{csv[17]}','#{csv[18]}','#{csv[19]}','#{csv[20]}','#{csv[21]}','#{csv[22]}','#{csv[23]}','#{csv[24]}')"
    end

    batch_size = 2000

    while !contact_values.empty?
      contacts_shifted = contact_values.shift(batch_size)
      contacts_sql = "INSERT INTO contacts(first_name, last_name, birthday, phone, email, twitter_account_link, facebook_account_link, linkedin_account_link, gplus_account_link, github_account_link, address_1, address_2, city, state, postal_code, country, company, title, company_address_1, company_address_2, company_city, company_state, company_postal_code, company_country, user_id) VALUES#{contacts_shifted.join(", ")}"
      ActiveRecord::Base.connection.execute(contacts_sql)
    end
  end

  def self.retrieve_contacts_oh_crud
  end

  def self.retrieve_contacts
  end

  def self.update_contacts_oh_crud
  end

  def self.update_contacts
  end

  def self.destroy_contacts_oh_crud(user)
    user.contacts.delete_all
  end

  def self.destroy_contacts(user_id)
    Contact.where(:user_id => user_id).delete_all
  end

  def self.create_contacts_csv(amount, filename)
    user_id = User.first.id
    CSV.open("lib/sample_data/#{filename}", "wb") do |csv|
      csv << [ 'First Name', 'Last Name', 'Birthday', 'Phone', 'Email', 'Twitter', 'Facebook', 'LinkedIn', 'Googple Plus', 'Github', 'Address 1', 'Address 2', 'City', 'State', 'Postal Code', 'Country', 'Company', 'Title', 'Company Address 1', 'Company Address 2', 'Company City', 'Company State', 'Company Postal Code', 'Company Country', 'User Id' ]
      amount.times do |n|
        first_name = Faker::Name.first_name.gsub("'","")
        last_name = Faker::Name.last_name.gsub("'","")
        email_address = "#{first_name.downcase}.#{last_name.downcase}.#{n}@example.com"
        profile_name = "#{first_name.downcase}_#{n}_sample"
        csv << [
          first_name, last_name, "1987-02-01", Faker::PhoneNumber.phone_number, email_address, "http://www.twitter.com/#{profile_name}", "http://www.facebook.com/#{profile_name}", "http://www.linkedin.com/in/#{profile_name}", "http://gplus.google.com/posts/#{profile_name}", "http://www.github.com/#{profile_name}", Faker::Address.street_address.gsub("'", ""), Faker::Address.secondary_address.gsub("'", ""), Faker::Address.city.gsub("'", ""), Faker::Address.state_abbr, Faker::Address.zip, "USA", Faker::Company.name.gsub("'", ""), Faker::Name.title.gsub("'", ""), Faker::Address.street_address.gsub("'", ""),  Faker::Address.secondary_address.gsub("'", ""),  Faker::Address.city.gsub("'", ""), Faker::Address.state_abbr, Faker::Address.zip, "USA", user_id
        ]
      end
    end
    puts "Done creating Faker CSV. Can be found in lib/sample_data/#{filename}"
  end

end