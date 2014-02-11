class ShopsController < ApplicationController
  require 'shops'
  include Shops

  def index
    @suggestions = Thing.sort_by_hot.take(12)
    @amazon_items = []
    @rakuten_items = []
    @y_items = []
    @y_a_items = []
    keyword = params[:k]
    sort = params[:sort] == "price" ? "price" : "default"
    if not keyword.blank?
      @amazon_items = get_amazon_items keyword, sort: sort
      @rakuten_items = get_rakuten_items keyword, sort: sort
      @y_items = get_yahoo_shopping_items keyword, sort: sort
      @y_a_items = get_yahoo_auction_items keyword, sort: sort
    end
  end

  def show
    @suggestions = Thing.sort_by_hot.take(10)
  end
end
