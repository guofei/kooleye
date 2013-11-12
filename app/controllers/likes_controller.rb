class LikesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    @thing = Thing.find(params[:thing_id])
    @like = @thing.likes.build
    @like.user = current_user
    if not @like.duplication?
      @like.save
      @thing.vote
    end
    redirect_to thing_path(@thing)
  end
end
