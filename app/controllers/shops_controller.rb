class ShopsController < ApplicationController
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

  private

  def get_amazon_items(keyword, sort: "dafault")
    res = Amazon::Ecs.item_search(keyword, :search_index => 'All', :response_group => 'Medium, OfferSummary')
    items = res.items.map do |item|
      {
        ec_site: "Amazon",
        url: item.get('DetailPageURL'),
        image: item.get('MediumImage/URL'),
        title: item.get('ItemAttributes/Title'),
        price: item.get('OfferSummary/LowestNewPrice/Amount')
      }
    end
    items = items.sort{ |a, b| a[:price].to_i <=> b[:price].to_i} if sort == "price"
    items
  end

  def get_rakuten_items(keyword, sort: "dafault")
    options = { :keyword => keyword }
    options[:sort] = "+itemPrice" if sort == "price"
    items = RakutenWebService::Ichiba::Item.search(options)
    items.first(10).map do |item|
      image = ActionController::Base.helpers.asset_path('noimage.jpg')
      if item["mediumImageUrls"].blank?
        if !item["smallImageUrls"].blank?
          image = item["smallImageUrls"][0]["imageUrl"]
        end
      else
        image = item["mediumImageUrls"][0]["imageUrl"]
      end
      {
        ec_site: "Rakuten",
        url: item["affiliateUrl"],
        image: image,
        price: item.price,
        title: item['itemName']
      }
    end
  end

  def get_yahoo_shopping_items(keyword, sort: "dafault")
    options = { :category_id => "1", :query => keyword }
    options[:sort] = "+price" if sort == "price"
    res = Yahoo::Api.get(Yahoo::Api::Shopping::ItemSearch, options)
    return [] if res["ResultSet"]["totalResultsReturned"] == "0"
    res["ResultSet"]["totalResultsReturned"].times.map do |i|
      {
        ec_site: "Yahoo Shopping",
        url: res["ResultSet"]["0"]["Result"]["#{i}"]["Url"],
        image: res["ResultSet"]["0"]["Result"]["#{i}"]["Image"]["Medium"],
        title: res["ResultSet"]["0"]["Result"]["#{i}"]["Name"],
        price: res["ResultSet"]["0"]["Result"]["#{i}"]["Price"]["_value"]
      }
    end
  end

  def get_yahoo_auction_items(keyword, sort: "dafault")
    options = { :query => keyword }
    options[:sort] = "bidorbuy" if sort == "price"
    res = Yahoo::Api.get(Yahoo::Api::Auction::Search, options)
    return [] if res["ResultSet"]["Result"]["Item"] == nil
    res["ResultSet"]["Result"]["Item"].map do |i|
      {
        ec_site: "Yahoo Auction",
        url: ENV["YAHOO_AUCTION_AFF_ID"] + i["AuctionItemUrl"],
        image: i["Image"],
        title: i["Title"],
        price: i["BidOrBuy"]
      }
    end
  end
end
