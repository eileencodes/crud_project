class FixContactModelBirthdayAndTitle < ActiveRecord::Migration
  def change
    change_column :contacts, :birthday, :date
    add_column :contacts, :title, :string
  end
end
