class HelpfulnessesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    helpfulness = current_user.helpfulnesses.build
    helpfulness.comment = Comment.find(params[:comment_id])
    helpfulness.save if not helpfulness.duplication?
    thing = Thing.find(params[:thing_id])
    redirect_to thing_path(thing)
  end
end
