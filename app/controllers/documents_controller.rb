class DocumentsController < ApplicationController
  load_and_authorize_resource param_method: :doc_params
  before_action :build_doc, :load_upload_times, only: :create

  def create
    if @document.save
      flash[:success] = t "success.doc_upload"
      current_user.add_coin Settings.coin_upload if @times < Settings.upload_times_in_month
      @document.category.send_create_cate_email if @flag_send_mail
    else
      flash[:danger] = t "error.doc_upload"
    end
    redirect_to root_url
  end

  def show; end

  def search
    @documents = Document.search_by_name_or_cate(params[:search]).approved.sort_by_name.paginate page: params[:page], per_page: Settings.per_page
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def build_doc
    @document = current_user.documents.build(doc_params)
    @flag_send_mail = false
    if params[:document][:category_attributes][:name].present?
      @document.category_id = nil
      @document.category.user = current_user
      @flag_send_mail = true
    end
    @document.doc.attach(params[:document][:doc])
  end

  def doc_params
    params.require(:document).permit :name, :doc, :category_id, category_attributes: [:name, :parent_id]
  end

  def load_upload_times
    @times = current_user.documents.find_in_month.size
  end
end
