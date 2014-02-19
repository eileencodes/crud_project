class AddDefaultUser < ActiveRecord::Migration
  def change
    User.create!({
      :email => "test@example.com",
      :password => "password",
      :password_confirmation => "password"
    })
  end
end
