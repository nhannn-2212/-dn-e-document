class Admin::DocumentsController < AdminController
  before_action :require_admin
  before_action :load_doc, only: :update
  before_action :load_all_docs, only: :index

  def index; end

  def update
    if @document.send("#{params[:document][:status]}!")
      load_all_docs
      respond_to do |format|
        format.html
        format.js
      end
    else
      flash[:danger] = t "error.update_document"
      redirect_to request.referer
    end
  end

  private

  def load_doc
    @document = Document.find_by id: params[:id]
    return if @document

    flash[:danger] = t "error.invalid_doc"
    redirect_to root_url
  end

  def load_all_docs
    @documents = Document.sort_by_created_at.paginate page: params[:page], per_page: Settings.per_page
  end
end
