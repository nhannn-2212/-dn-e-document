class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @document = current_user.documents.build
    @document.build_category
    @documents = Document.approved.sort_by_name.paginate(page: params[:page], per_page: Settings.per_page)
  end
end
