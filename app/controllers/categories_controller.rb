class CategoriesController < ApplicationController
  include ApplicationHelper

  def index
    @categories = current_user.categories
  end

  def show
    @category = Category.find(params[:id])
    @contacts = @category.contacts.page(params[:page])
  end

  private
  def category_params
    params.require(:category).permit(:name, :description, :user_id)
  end
end
