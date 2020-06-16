class FavoritesController < ApplicationController
  before_action :load_favorite, only: :destroy

  def create
    @document = Document.find_by id: params[:document_id]
    if @document
      current_user.favorite @document
      respond_to do |format|
        format.html{redirect_to root_url}
        format.js
      end
    else
      flash[:danger] = t "error.favorite"
      redirect_to root_url
    end
  end

  def destroy
    @document = @fav.document
    if @document
      current_user.unfavorite @document
      respond_to do |format|
        format.html{redirect_to root_url}
        format.js
      end
    else
      flash[:danger] = t "error.invalid_doc"
      redirect_to root_url
    end
  end

  private

  def load_favorite
    @fav = Favorite.find_by id: params[:id]
    return if @fav

    flash[:danger] = t "error.invalid_fav"
    redirect_to root_url
  end
end
