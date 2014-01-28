class UpdateContactsColumns < ActiveRecord::Migration
  def change
    add_column :contacts, :city, :string
    remove_column :contacts, :photo
  end
end
