class ContactsController < ApplicationController
  include ApplicationHelper

  def index
    @contacts = current_user.contacts.page(params[:page])
  end

  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to user_contacts_path(current_user.id), notice: "Contact successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(contact_params)
        format.html { redirect_to edit_user_contact_path(current_user, @contact), notice: "Contact successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to user_contacts_path(current_user)
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone, :email, :address_1, :address_2, :city, :state, :postal_code, :country, :birthday, :prefix, :suffix, :company, :company_address_1, :company_address_2, :company_city, :company_state, :company_postal_code, :company_country, :user_id, :twitter_account_link, :facebook_account_link, :linkedin_account_link, :gplus_account_link, :github_account_link, :title)
  end
end
