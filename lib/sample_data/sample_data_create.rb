require 'csv'

module SampleDataCreate
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

  def self.create_contacts_optimized
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

end
