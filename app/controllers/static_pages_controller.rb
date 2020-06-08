class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @document = current_user.documents.build
    @docs = Document.by_title.paginate(page: params[:page], per_page: Settings.per_page)
    @categories = Category.by_name.pluck(:name, :id)
  end
end
