class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @document = current_user.documents.build
    @docs = current_user.documents
    @categories = Category.by_name.pluck(:name, :id)
  end
end
