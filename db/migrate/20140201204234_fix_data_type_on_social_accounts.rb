class FixDataTypeOnSocialAccounts < ActiveRecord::Migration
  def change
    change_column :social_accounts, :social_account_type_id, :integer
  end
end
