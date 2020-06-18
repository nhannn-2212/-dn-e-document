class DownloadsController < ApplicationController
  authorize_resource class: false
  before_action :load_document, :load_download_times

  def show
    if @times >= Settings.times_download_free
      unless (current_user == @document.user && current_user.coin >= Settings.coin_my_file) || (current_user != @document.user && current_user.coin >= Settings.coin)
        flash[:warning] = t "warning.no_coin"
        return redirect_to root_url
      end
      minus_coin
    end
    download_update_history_db
  end

  private

  def load_document
    @document = Document.find_by id: params[:id]
    return if @document

    flash[:danger] = t "invalid_file"
    redirect_to root_url
  end

  def minus_coin
    current_user.minus_coin Settings.coin_my_file if current_user == @document.user
    current_user.minus_coin Settings.coin if current_user != @document.user
  end

  def download_update_history_db
    current_user.create_history @document.id
    send_data @document.doc.download, filename: @document.doc.filename.to_s,
        content_type: @document.doc.content_type
  end

  def load_download_times
    @times = current_user.histories.find_in_month.size
  end
end
