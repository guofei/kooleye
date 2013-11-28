# -*- coding: utf-8 -*-
require 'uri'

class BuysController < ApplicationController
  def index
    thing = Thing.find(params[:thing_id])
    amazon = URI.escape("http://www.amazon.co.jp/s/?_encoding=UTF8&camp=1207&creative=8415&linkCode=shr&tag=rookit03-22&_mk_ja_JP=カタカナ&url=search-alias%3Daps&field-keywords=#{thing.name}")
    redirect_to amazon
  end

  private
  def valid?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end
end
