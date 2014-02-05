class Contact < ActiveRecord::Base
  has_many :categorizations, dependent: :delete_all
  has_many :categories, through: :categorizations

  def prefix_options
    [['Mr.', 'Mr.'], ['Mrs.', 'Mrs.'], ['Ms.', 3], ['Miss', 4]]
  end

  def full_name
    name = ""
    name << "#{prefix} " if prefix.present?
    if first_name && last_name
      name << "#{first_name} #{last_name}"
    elsif first_name
      name << first_name
    elsif last_name
      name << last_name
    else
      name
    end
    name << " #{suffix}" if suffix.present?
    name
  end

  def address
    address = ""
    address << address_1
    address << "<br />#{address_2}" if address_2.present?
    address << "<br />#{city}, #{state} #{postal_code}"
    address << "<br />#{country}"
    address.html_safe
  end

  def company_address
    address = ""
    address << company_address_1
    address << "<br />#{company_address_2}" if company_address_2.present?
    address << "<br />#{company_city}, #{company_state} #{company_postal_code}"
    address << "<br />#{company_country}"
    address.html_safe
  end
end
