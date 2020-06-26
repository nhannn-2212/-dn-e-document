class Admin::DocumentsController < AdminController
  load_and_authorize_resource
  before_action :check_draft_doc, :check_change_status, :update_status_block, only: :update
  before_action :load_docs, only: :index

  def index; end

  def update
    check_approve
    load_docs
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

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

    @document.user.send_block_email if @document.user.block_user
  end

  def check_approve
    @document.user.send_upload_email(@document) if params[:document][:status] == Settings.status_approved
  end

  def check_change_status
    return if @document.status != params[:document][:status]

    flash[:warning] = t "warning.nothing_update"
    redirect_to request.referer
  end

  def update_status_block
    ActiveRecord::Base.transaction do
      @document.send("#{params[:document][:status]}!")
      check_user_block
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: e.to_s
    }, status: :not_found
  end
end
