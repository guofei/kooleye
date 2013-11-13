class HavablesController < ApplicationController
  before_filter :authenticate_user!, only: [:create]
  def create
    @thing = Thing.find(params[:thing_id])
    @havable = @thing.havables.build
    @havable.user = current_user
    if not @havable.duplication?
      @havable.save
    end
    redirect_to thing_path(@thing)
  end
end
