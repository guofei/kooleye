class ThingsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  def new
    @thing = Thing.new
    @image = @thing.images.build
    @image.thing_token = @thing.generate_token
  end

  def index
    if(params[:sort] == "hot")
      @things = Thing.sort_by_hot.page params[:page]
    else
      @things = Thing.page params[:page]
    end
    @sort = params[:sort]
  end

  def show
    @thing = Thing.find(params[:id])
  end

  def create
    @thing = Thing.new(thing_params)
    @thing.user = current_user
    @thing.images << Image.where(:thing_token => @thing.token)
    if @thing.save
      send_to_sns
      redirect_to thing_path(@thing)
    else
      @image = @thing.images.build
      @image.thing_token = @thing.token
      render 'new'
    end
  end

  private
  def thing_params
    params.require(:thing).permit(:name, :summary, :introduction, :video, :token, :images_attributes => [:file])
  end

  def send_to_sns
    current_user.send_to_twitter("#{@thing.name} #{@thing.summary} #{@thing.introduction}", url_for(@thing)) if params[:sync][:twitter] == "1"
    current_user.send_to_facebook(@thing.name, @thing.summary, url_for(@thing)) if params[:sync][:facebook] == "1"
  end
end
