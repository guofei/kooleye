# -*- coding: utf-8 -*-
module ShopsHelper
  def amazon_url(keyword)
    amazon = URI.escape("http://www.amazon.co.jp/s/?_encoding=UTF8&camp=1207&creative=8415&linkCode=shr&tag=rookit03-22&field-keywords=#{keyword}")
  end

  def rakuten_url(keyword)
    keyword_encode = URI.escape(keyword)
    rakuten = "http://hb.afl.rakuten.co.jp/hgc/0bb72de0.b993a849.0bb72de1.7da13ad9/?pc=http%3a%2f%2fsearch.rakuten.co.jp%2fsearch%2fmall%2f#{keyword_encode}%2f-%2f%3fscid%3daf_link_urlmail&m=http%3a%2f%2fm.rakuten.co.jp%2f"
  end

  def yahoo_s_url(keyword)
    keyword_encode = URI.escape(keyword)
    y = ENV["YAHOO_AUCTION_AFF_ID"] + CGI.escape("http://search.shopping.yahoo.co.jp/search?first=1&dnow=&dtype=&tab_ex=commerce&fr=shp-prop&sc_i=shp_pc_top_searchBox&p=#{keyword_encode}&ea=&cid=")
  end

  def yahoo_a_url(keyword)
    keyword_encode = URI.escape(keyword)
    y = ENV["YAHOO_AUCTION_AFF_ID"] + CGI.escape("http://auctions.search.yahoo.co.jp/search?auccat=&p=#{keyword_encode}&tab_ex=commerce&ei=utf-8")
  end

  def item_url(item)
    if item[:ec_site] == "kooleye"
      item[:url]
    else
      aff_link(item[:url])
    end
  end
end
