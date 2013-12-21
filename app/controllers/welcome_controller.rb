class WelcomeController < ApplicationController
  def index
    #@hot_things = Kaminari.paginate_array(Thing.sort_by_hot_and_time).page(params[:page])
    @hot_things = Thing.sort_by_hot.page params[:page]
    @new_things = Thing.take(10)
    @newest = []
    @newest = Thing.offset(10).limit(5) if not params[:page]
  end
end
