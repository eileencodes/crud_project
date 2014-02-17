require 'faker'
require 'csv'

module SampleDataSetup
  def self.create_contacts_csv(amount, filename, user_id)
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

  def self.create_categories
    user = User.first
    [ 'Family', 'Friends', 'Coworkers', 'Networking', 'Businesses', 'Medical', 'Other'].each do |category|
      Category.create({
        :name => category,
        :description => "Sample Data Category",
        :user_id => user.id
      })
    end
  end

  def self.create_categorizations
    user = User.first
    category = Category.where(:name => 'Coworkers').first
    categorization_values = []
    Contact.all.each do |contact|
      categorization_values << "('#{contact.id}', '#{category.id}')"
    end

    batch_size = 2000

    while !categorization_values.empty?
      categorizations_shifted = categorization_values.shift(batch_size)
      categorizations_sql = "INSERT INTO categorizations(contact_id, category_id) VALUES#{categorizations_shifted.join(", ")}"
      ActiveRecord::Base.connection.execute(categorizations_sql)
    end
  end

  def self.build_everything
    create_contacts_optimized
    create_categories
    create_categorizations
  end

  def self.create_categories_and_relationships
    create_categories
    create_categorizations
  end

  def self.tear_down_everything
    Contact.delete_all
    Category.delete_all
    Categorization.delete_all
  end

  def self.tear_down_categories_and_relationships
    Category.delete_all
    Categorization.delete_all
  end

end
