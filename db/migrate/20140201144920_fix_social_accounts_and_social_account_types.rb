class FixSocialAccountsAndSocialAccountTypes < ActiveRecord::Migration
  def change
    rename_column :social_accounts, :link, :profile_handle
    add_column :social_account_types, :profile_link, :string
  end
end
