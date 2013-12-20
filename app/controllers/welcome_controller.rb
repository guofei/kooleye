class WelcomeController < ApplicationController
  def index
    @hot_things = Thing.sort_by_hot.page params[:page]
    @new_things = Thing.sort_by_new[0..10]
    @newest = []
    @newest = Thing.sort_by_new[0..4] if not params[:page]
  end
end
