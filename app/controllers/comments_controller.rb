class CommentsController < ApplicationController
  #before_filter :authenticate_user!, only: [:create]
  def create
    @thing = Thing.find(params[:thing_id])
    if not user_signed_in?
      if not verify_recaptcha
        flash[:recaptcha_error] = 'Captcha is incorrect please try again.'
        respond_to do |format|
          format.html { redirect_to thing_path(@thing) }
          format.js
        end
        return
      end
    end
    @comment = @thing.comments.build(comment_params)
    @comment.user = current_user
    @comment.save

    if user_signed_in?
      current_user.send_to_twitter("#{@thing.name} #{@comment.content}", url_for(@thing)) if params[:sync][:twitter] == "1"
      current_user.send_to_facebook(@comment.content, @thing.name, url_for(@thing)) if params[:sync][:facebook] == "1"
    end
    respond_to do |format|
      format.html { redirect_to thing_path(@thing) }
      format.js
    end
  end

  private
  def authenticate_user!
    unless current_user
      respond_to do |format|
        format.js { render "shared/login" }
        format.html { super }
      end
    end
  end
  def comment_params
    params.require(:comment).permit(:content)
  end
end
