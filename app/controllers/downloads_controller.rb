class DownloadsController < ApplicationController
  before_action :load_document

  def show
    unless (current_user == @document.user && current_user.coin >= Settings.coin_my_file) || (current_user != @document.user && current_user.coin >= Settings.coin)
      flash[:warning] = t "warning.no_coin"
      return redirect_to root_url
    end

    download_update_db
  end

  private

  def load_document
    @document = Document.find_by id: params[:id]
    return if @document

    flash.now[:danger] = t "invalid_file"
    redirect_to root_url
  end

  def download_update_db
    current_user.minus_coin Settings.coin_my_file if current_user == @document.user
    current_user.minus_coin Settings.coin if current_user != @document.user
    send_data @document.doc.download, filename: @document.doc.filename.to_s,
        content_type: @document.doc.content_type
  end
end
