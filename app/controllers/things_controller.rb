class ThingsController < ApplicationController
  def new
    @thing = Thing.new
  end

  def index
    @things = Thing.all
  end

  def show
    @thing = Thing.find(params[:id])
  end
end
