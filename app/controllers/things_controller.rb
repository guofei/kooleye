class ThingsController < ApplicationController
  def index
    @things = Thing.all
  end

  def show
    @thing = Thing.first
  end
end
