class VotesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    @type = params[:type] == "have" ? "have":"like"
    @thing = Thing.find(params[:thing_id])
    @vote = @thing.votes.build
    @vote.user = current_user
    @vote.vote_type = @type
    @vote.save if not @vote.duplication?
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
