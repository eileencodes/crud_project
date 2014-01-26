class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :address_1
      t.string :address_2
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :photo
      t.string :company
      t.string :company_phone
      t.string :company_address_1
      t.string :company_address_2
      t.string :company_city
      t.string :company_state
      t.string :company_postal_code
      t.string :company_country
      t.date :birthday
      t.string :suffix
      t.string :prefix
    end
  end
end
