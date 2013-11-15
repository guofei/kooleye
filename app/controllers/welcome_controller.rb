class WelcomeController < ApplicationController
  def index
    @hot_things = Thing.sort_by_hot
    @new_things = Thing.sort_by_new[0, 10]
  end
end
