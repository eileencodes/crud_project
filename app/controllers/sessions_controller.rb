class SessionsController < ApplicationController
  before_filter :login_required, :except => [:create]

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_contacts_path(user.id), notice: 'You have been logged in!'
    else
      flash[:notice] = 'Your username or password is incorrect'
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "You have been logged out"
  end
end
