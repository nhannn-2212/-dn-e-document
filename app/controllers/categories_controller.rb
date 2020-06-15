class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = t "success.create_category"
    else
      flash[:error] = t "error.create_category"
    end
    redirect_to request.referer
  end

  private

  def category_params
    params.require(:category).permit :name, :parent_id
  end
end
