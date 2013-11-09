class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    @thing = Thing.find(params[:thing_id])
    @comment = @thing.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    redirect_to thing_path(@thing)
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
