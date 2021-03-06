class Admin::CategoriesController < AdminController
  before_action :require_admin
  before_action :load_category, only: %i(edit update)

  def index
    @categories = Category.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page)
  end

  def edit; end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "success.update_category"
      redirect_to request.referer
    else
      flash[:danger] = t "error.update_category"
      render :edit
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = t "success.create_category"
      @category.send_create_cate_email
    else
      flash[:error] = t "error.create_category"
    end
    redirect_to request.referer
  end

  private

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t "error.invalid_category"
    redirect_to request.referer
  end

  def category_params
    params.require(:category).permit :name, :parent_id
  end
end
