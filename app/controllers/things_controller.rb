class ThingsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  def new
    #FIXME: Need Refactoring : change "add images" to ajax
    n = params["n"].nil? ? 1 : params["n"].to_i
    @thing = Thing.new
    n.times { @thing.images.build }
  end

  def index
    @things = Thing.all
  end

  def show
    @thing = Thing.find(params[:id])
  end

  def create
    @thing = Thing.new(thing_params)
    @thing.user = current_user
    @thing.votes = 0
    if @thing.save
      redirect_to thing_path(@thing)
    else
      1.times { @thing.images.build }
      render 'new'
    end
  end

  private
  def thing_params
    params.require(:thing).permit(:name, :summary, :introduction, :video, :images_attributes => [:file])
  end
end
