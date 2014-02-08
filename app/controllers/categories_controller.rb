class CategoriesController < ApplicationController
  include ApplicationHelper

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to user_categories_path(current_user.id), notice: "Category was successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @category = Category.find(params[:id])
    @contacts = @category.contacts.page(params[:page])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(category_params)
        format.html { redirect_to edit_user_category_path(current_user, @category), notice: "Category successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to user_categories_path(current_user)
  end

  private
  def category_params
    params.require(:category).permit(:name, :description, :user_id)
  end
end
