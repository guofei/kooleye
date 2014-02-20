class ShopsController < ApplicationController
  require 'shops'
  include Shops

  helper_method :search_engine_keyword

  def index
    search_engine_keyword
    @suggestions = Thing.sort_by_hot.limit(12)
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
    @items = []
    if not keyword.blank?
      things = Thing.search(name_cont: keyword).result
      things.each do |thing|
        item = {
          ec_site: "kooleye",
          publisher: thing.name + " " + thing.summary,
          url: thing_path(thing),
          image: thing.images.first.normal_url,
          title: thing.name
        }
        @items << item
      end
    end
    loop do
      am = @amazon_items.shift
      rt = @rakuten_items.shift
      ys = @y_items.shift
      ya = @y_a_items.shift
      break if am == nil and rt == nil and ys == nil and ya == nil
      @items << am if am
      @items << rt if rt
      @items << ys if ys
      @items << ya if ya
    end
    @items = @items.sort{ |a, b| a[:price].to_i <=> b[:price].to_i} if sort == "price"
  end

  def show
    @suggestions = Thing.sort_by_hot.take(10)
  end

  private

  def search_engine_keyword
    begin
      querys = CGI::parse URI.parse(request.headers[:referer]).query
      query = querys["keywords"][0] if querys["keywords"]
      query = querys["q"][0] if querys["q"]
      query = querys["p"][0] if querys["p"]
      if not query.blank? and request.headers[:referer].downcase.include?("=euc-jp")
        query = query.encode "UTF-8", "EUC-JP"
      end
      if not params[:k].blank?
        query = nil if params[:k].include?(query)
      end
    rescue
      query = nil
    end
    query
  end
end
