class WelcomeController < ApplicationController
  def index
    #@hot_things = Kaminari.paginate_array(Thing.sort_by_hot_and_time).page(params[:page])
    @center_things = Thing.sort_by_hot.page params[:page]
    @sider_things = Thing.take(10)
    @top_things = []
    @top_things = Thing.offset(10).limit(4) if not params[:page]
  end
end
