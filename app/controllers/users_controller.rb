class UsersController < ApplicationController
  include ApplicationHelper

  def index
    @users = User.all
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to user_contacts_path(@user.id), notice: "Your account has been successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to user_contacts_path(@user.id), notice: 'Your account has been successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    User.destroy(params[:id])
    redirect_to root_url
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :address_1, :address_2, :city, :state, :postal_code, :country, :password, :password_confirmation)
  end

end
