class DocumentsController < ApplicationController
  before_action :logged_in?
  before_action :build_doc, only: :create

  def create
    if @document.save
      flash[:success] = t "success.doc_upload"
    else
      flash.now[:danger] = t "error.doc_upload"
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
    if params[:search]
      @docs = Document.left_outer_joins(:category).where("documents.name LIKE :search OR categories.name LIKE :search", search: "%#{params[:search]}%").paginate(page: params[:page], per_page: Settings.per_page)
    else
      @docs = Document.by_title.paginate(page: params[:page], per_page: Settings.per_page)
    end
    respond_to do |format|
      format.js
      format.html { redirect_to root_url }
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
end
