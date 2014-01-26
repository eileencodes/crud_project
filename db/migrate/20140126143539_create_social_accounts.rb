class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.string :link
      t.integer :contact_id
      t.string :social_account_type_id
    end
  end
end
