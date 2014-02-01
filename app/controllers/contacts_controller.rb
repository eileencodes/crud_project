class ContactsController < ApplicationController
  include ApplicationHelper

  def index
    @contacts = current_user.contacts
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
end
