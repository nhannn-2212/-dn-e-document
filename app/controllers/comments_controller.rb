class CommentsController < ApplicationController
  before_action :build_comment, only: :create
  before_action :load_comment, only: %i(edit destroy update)

  def new
    @comment = Comment.new
  end

  def create
    if @comment.save
      flash[:success] = t "success.post_comment"
    else
      flash[:danger] = t "error.post_comment"
    end
    redirect_to request.referer
  end

  def destroy
    if @comment.destroy
      flash[:success] = t "success.delete_comment"
    else
      flash[:danger] = t "error.delete_comment"
    end
    redirect_to request.referer
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @comment.update_attributes com_params
      flash[:success] = t "success.update_comment"
    else
      flash[:danger] = t "error.update_comment"
    end
    redirect_to @comment.document
  end

  private

  def load_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment

    flash[:danger] = t "error.invalid_comment"
    redirect_to request.referer
  end

  def build_comment
    @comment = current_user.comments.build com_params
    if params[:comment_id].present?
      @comment.reply_comment_id = params[:comment_id]
      load_reply_comment params[:comment_id]
      doc_id = @reply_comment.document_id
    else
      doc_id = params[:document_id]
    end
    load_document doc_id
    @comment.document_id = @document.id
  end

  def com_params
    params.require(:comment).permit :content, :comment_id, :document_id
  end

  def load_document doc_id
    @document = Document.find_by id: doc_id
    return if @document

    flash[:danger] = t "error.invalid_doc"
    redirect_to root_url
  end

  def load_reply_comment com_id
    @reply_comment = Comment.find_by id: com_id
    return if @reply_comment

    flash[:danger] = t "error.invalid_comment"
    redirect_to root_url
  end
end
