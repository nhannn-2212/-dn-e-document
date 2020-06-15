module CategoriesHelper
  def select_categories
    Category.sort_by_name.pluck :name, :id
  end
end
