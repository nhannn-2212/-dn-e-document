class Admin::DocumentsController < AdminController
  before_action :load_doc, :check_draft_doc, only: :update
  before_action :load_docs, only: :index

  def index; end

  def update
    if @document.send("#{params[:document][:status]}!")
      check_user_block
      load_docs
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

  def check_draft_doc
    return unless @document.draft?

    flash[:danger] = t "error.edit_draft_doc"
    redirect_to request.referer
  end

  def load_docs
    @documents = Document.not_draft.sort_by_created_at.paginate page: params[:page], per_page: Settings.per_page
  end

  def check_user_block
    ban_times = @document.user.documents.ban.size
    return if ban_times < Settings.times_upload_invalid || params[:document][:status] != Settings.status_ban

    @document.user.block_user
  end
end
