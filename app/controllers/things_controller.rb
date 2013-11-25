class ThingsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  def new
    n = params["n"].nil? ? 1 : params["n"].to_i
    @thing = Thing.new
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
      if(params[:thing][:images])
        params[:thing][:images].each do |i|
          image = Image.find(i)
          image.thing = @thing
          image.save
        end
      end

      current_user.send_to_twitter("#{@thing.name} #{@thing.summary} #{@thing.introduction}", url_for(@thing)) if params[:sync][:twitter] == "1"
      current_user.send_to_facebook(@thing.name, @thing.summary, url_for(@thing)) if params[:sync][:facebook] == "1"
      redirect_to thing_path(@thing)
    else
      render 'new'
    end
  end

  private
  def thing_params
    params.require(:thing).permit(:name, :summary, :introduction, :video, :images_attributes => [:file])
  end
end
