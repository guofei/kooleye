module Shops
  def get_amazon_items(keyword, sort: "dafault")
    Rails.cache.fetch("amazon_#{keyword}_#{sort}", expires_in: 1.hour) do
      items = []
      [1, 2].each do |page|
        res = Amazon::Ecs.item_search(keyword, :search_index => 'All', :response_group => 'Medium, OfferSummary', :ItemPage => page)
        res.items.each do |item|
          items.push({
                       ec_site: "Amazon", url: item.get('DetailPageURL'),
                       image: item.get('MediumImage/URL'),
                       title: item.get('ItemAttributes/Title'),
                       price: item.get('OfferSummary/LowestNewPrice/Amount')
                     })
        end
      end
      items = items.sort{ |a, b| a[:price].to_i <=> b[:price].to_i} if sort == "price"
      items
    end
  end

  def get_rakuten_items(keyword, sort: "dafault")
    Rails.cache.fetch("rakuten_#{keyword}_#{sort}", expires_in: 1.hour) do
      options = { :keyword => keyword }
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
          ec_site: "Rakuten",
          url: item["affiliateUrl"],
          image: image,
          price: item.price,
          title: item['itemName']
        }
      end
    end
  end

  def get_yahoo_shopping_items(keyword, sort: "dafault")
    Rails.cache.fetch("yahoo_s_#{keyword}_#{sort}", expires_in: 1.hour) do
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
  end

  def get_yahoo_auction_items(keyword, sort: "dafault")
    Rails.cache.fetch("yahoo_a_#{keyword}_#{sort}", expires_in: 1.hour) do
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
end
