class VotesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    @thing = Thing.find(params[:thing_id])
    @like = @thing.votes.build
    @like.user = current_user
    @like.save if not @like.duplication?
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
end
