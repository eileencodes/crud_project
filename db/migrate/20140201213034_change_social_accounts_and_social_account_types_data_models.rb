class ChangeSocialAccountsAndSocialAccountTypesDataModels < ActiveRecord::Migration
  def change
    drop_table :social_account_types
    drop_table :social_accounts
    add_column :contacts, :twitter_account_link, :string
    add_column :contacts, :facebook_account_link, :string
    add_column :contacts, :linkedin_account_link, :string
    add_column :contacts, :gplus_account_link, :string
    add_column :contacts, :github_account_link, :string
  end
end
