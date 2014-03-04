# -*- coding: utf-8 -*-
module Shops
  def get_items(keyword, sort: "dafault", page: 1)
    return [] if keyword.blank?

    sort = "default" if sort != "price"
    page = 1 if page.to_i < 1

    items4 = [ get_amazon_items(keyword, sort: sort, page: page),
               get_rakuten_items(keyword, sort: sort, page: page),
               get_yahoo_shopping_items(keyword, sort: sort, page: page),
               get_yahoo_auction_items(keyword, sort: sort, page: page) ].sort{ |a, b| b.length <=> a.length }

    items = items4[0].zip(items4[1], items4[2], items4[3]).reduce([]){ |all_arr, arr| all_arr + arr }.compact
    items = items.sort{ |a, b| a[:price].to_i <=> b[:price].to_i} if sort == "price"
    items
  end

  def get_amazon_items(keyword, sort: "dafault", page: 1)
    return [] if page * 2 > 6
    Rails.cache.fetch("amazon_#{keyword}_#{sort}_#{page}") do
      items = []
      [1, 0].each do |i|
        next if page * 2 - i > 5
        res = Amazon::Ecs.item_search(keyword, search_index: 'All', response_group: 'Medium, OfferSummary', ItemPage: page * 2 - i)
        res.items.each do |item|
          items.push({
                       ec_site: "amazon",
                       publisher: "Amazon: #{item.get('ItemAttributes/Publisher')}",
                       url: item.get('DetailPageURL'),
                       image: item.get('MediumImage/URL'),
                       title: item.get('ItemAttributes/Title'),
                       price: item.get('OfferSummary/LowestNewPrice/Amount')
                     })
        end
      end
      items
    end
  end

  def get_rakuten_items(keyword, sort: "dafault", page: 1)
    keyword = keyword.gsub(/[|&]/, " ")
    return [] if page > 100
    Rails.cache.fetch("rakuten_#{keyword}_#{sort}_#{page}") do
      options = { :keyword => keyword }
      options[:hits] = 15
      options[:page] = page
      options[:sort] = "+itemPrice" if sort == "price"
      items = RakutenWebService::Ichiba::Item.search(options)
      items.first(15).map do |item|
        image = ActionController::Base.helpers.asset_path('noimage.jpg')
        if item["mediumImageUrls"].blank?
          if !item["smallImageUrls"].blank?
            image = item["smallImageUrls"][0]["imageUrl"]
          end
        else
          image = item["mediumImageUrls"][0]["imageUrl"]
        end
        {
          ec_site: "rakuten",
          publisher: "楽天ショップ: #{item['shopName']}",
          url: item["affiliateUrl"],
          image: image,
          price: item.price,
          title: item['itemName']
        }
      end
    end
  end

  def get_yahoo_shopping_items(keyword, sort: "dafault", page: 1)
    return [] if page > 1
    Rails.cache.fetch("yahoo_s_#{keyword}_#{sort}") do
      options = { :category_id => "1", :query => keyword }
      options[:sort] = "+price" if sort == "price"
      res = Yahoo::Api.get(Yahoo::Api::Shopping::ItemSearch, options)
      return [] if res["ResultSet"] == nil or res["ResultSet"]["totalResultsReturned"] == "0"
      res["ResultSet"]["totalResultsReturned"].times.map do |i|
        {
          ec_site: "yahoo shopping",
          publisher: "Yahoo!ショッピング: " + res["ResultSet"]["0"]["Result"]["#{i}"]["Store"]["Name"],
          url: res["ResultSet"]["0"]["Result"]["#{i}"]["Url"],
          image: res["ResultSet"]["0"]["Result"]["#{i}"]["Image"]["Medium"],
          title: res["ResultSet"]["0"]["Result"]["#{i}"]["Name"],
          price: res["ResultSet"]["0"]["Result"]["#{i}"]["Price"]["_value"]
        }
      end
    end
  end

  def get_yahoo_auction_items(keyword, sort: "dafault", page: 1)
    return [] if page > 1
    Rails.cache.fetch("yahoo_a_#{keyword}_#{sort}") do
      options = { :query => keyword }
      options[:sort] = "bidorbuy" if sort == "price"
      res = Yahoo::Api.get(Yahoo::Api::Auction::Search, options)
      items = res["ResultSet"]["Result"]["Item"]
      if items == nil
        items = []
      elsif items.instance_of?(Hash)
        items = [res["ResultSet"]["Result"]["Item"]]
      end
      items.map do |i|
        {
          ec_site: "yahoo auction",
          publisher: "#{i['Seller']['Id']} ヤフオクで#{keyword}検索",
          url: ENV["YAHOO_AUCTION_AFF_ID"] + i["AuctionItemUrl"],
          image: i["Image"],
          title: i["Title"],
          price: i["BidOrBuy"]
        }
      end
    end
  end
end
