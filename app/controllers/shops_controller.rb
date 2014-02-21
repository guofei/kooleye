class ShopsController < ApplicationController
  require 'shops'
  include Shops

  def index
    @suggestions = Thing.sort_by_hot.limit(12)
    @new_comments = Comment.limit(8).includes(:thing, :user)
    @keyword = get_keyword
    @search_engine_keyword = get_referrer_keyword
    @items = get_thing_items(@keyword) + get_items([@search_engine_keyword, @keyword], sort: params[:sort])
  end

  def show
    @suggestions = Thing.sort_by_hot.limit(12)
    @new_comments = Comment.limit(8).includes(:thing, :user)
    @keyword = get_keyword
    @search_engine_keyword = get_referrer_keyword
    @items = get_thing_items(@keyword) + get_items([@search_engine_keyword, @keyword], sort: params[:sort])
    render 'index'
  end

  private

  def get_keyword
    return nil if params[:k].blank?
    return params[:k]
  end

  def get_referrer_keyword
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

  def get_thing_items(keyword)
    items = []
    things = Thing.search(name_or_summary_cont: keyword).result
    things.each do |thing|
      image = ActionController::Base.helpers.asset_path('noimage.jpg')
      image = thing.images.first.normal_url if thing.images.first
      item = {
        ec_site: "kooleye",
        publisher: thing.name,
        url: thing_path(thing),
        image: image,
        title: thing.summary
      }
      items << item
    end
    items
  end
end
