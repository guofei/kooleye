class ThingsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  def new
    @thing = Thing.new
    3.times { @thing.images.build }
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
    if @thing.save
      redirect_to thing_path(@thing)
    else
      3.times { @thing.images.build }
      render 'new'
    end
  end

  private
  def thing_params
    params.require(:thing).permit(:name, :summary, :introduction, :images_attributes => [:file])
  end
end
