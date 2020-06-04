class DocumentsController < ApplicationController
  before_action :logged_in?
  before_action :build_doc, :load_upload_times, only: :create

  def create
    if @document.save
      flash[:success] = t "success.doc_upload"
      current_user.add_coin Settings.coin_upload if @times < 10
    else
      flash[:danger] = t "error.doc_upload"
    end
    redirect_to root_url
  end

  def show
    @document = Document.find_by id: params[:id]
    return if @document

    flash[:danger] = t "error.invalid_doc"
    redirect_to root_url
  end

  def search
    @documents = Document.search(params[:search]).approved.sort_by_name.paginate page: params[:page], per_page: Settings.per_page

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def build_doc
    @document = current_user.documents.build(doc_params)
    @document.doc.attach(params[:document][:doc])
  end

  def doc_params
    params.require(:document).permit :name, :doc, :category_id
  end

  def load_upload_times
    @times = current_user.documents.find_in_month.size
  end
end
