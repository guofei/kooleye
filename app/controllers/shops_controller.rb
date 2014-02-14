class ShopsController < ApplicationController
  require 'shops'
  include Shops

  def index
    search_engine_keyword
    @suggestions = Thing.sort_by_hot.take(12)
    @new_comments = Comment.limit(8).includes(:thing, :user)
    @amazon_items = []
    @rakuten_items = []
    @y_items = []
    @y_a_items = []
    keyword = params[:k]
    sort = params[:sort] == "price" ? "price" : "default"
    [search_engine_keyword, keyword].each do |k|
      if not k.blank?
        @amazon_items.concat(get_amazon_items k, sort: sort)
        @rakuten_items.concat(get_rakuten_items k, sort: sort)
        @y_items.concat(get_yahoo_shopping_items k, sort: sort)
        @y_a_items.concat(get_yahoo_auction_items k, sort: sort)
      end
    end
  end

  def show
    @suggestions = Thing.sort_by_hot.take(10)
  end

  private

  def search_engine_keyword
    begin
      querys = CGI::parse URI.parse(request.headers[:referer]).query
      query = querys["q"][0] if querys["q"]
      query = querys["p"][0] if querys["p"]
      if not params[:k].blank?
        query = nil if params[:k].include?(query)
      end
    rescue
      query = nil
    end
    query
  end
end
