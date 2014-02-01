class AddDefaultSocialAccountTypes < ActiveRecord::Migration
  def change
    twitter = SocialAccountType.create!({ :name => "Twitter", :profile_link => "http://www.twitter.com/" })
    facebook = SocialAccountType.create!({ :name => "Facebook", :profile_link => "http://www.facebook.com/" })
    profile_linkedin = SocialAccountType.create!({ :name => "LinkedIn", :profile_link => "http://www.linkedin.com/in/" })
    gplus = SocialAccountType.create!({ :name => "Google Plus", :profile_link => "http://plus.google.com/" })
    github = SocialAccountType.create!({ :name => "GitHub", :profile_link => "http://www.github.com/" })
  end
end
