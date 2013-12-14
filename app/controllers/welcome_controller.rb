class WelcomeController < ApplicationController
  def index
    ##Fixme: use activerecord
    @hot_things = Kaminari.paginate_array(Thing.sort_by_new.limit(2) + Thing.sort_by_hot).page params[:page]
    #@hot_things = (Thing.sort_by_new.limit(2) + Thing.sort_by_hot).page params[:page]
    @new_things = Thing.sort_by_new[0, 10]
  end
end
