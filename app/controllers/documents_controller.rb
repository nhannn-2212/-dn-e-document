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

  private

  def doc_params
    params.require(:document).permit :name, :doc, :category_id
  end

  def build_doc
    @document = current_user.documents.build(doc_params)
    @document.doc.attach(params[:document][:doc])
  end
end
