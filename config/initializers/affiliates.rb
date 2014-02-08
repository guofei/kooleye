Amazon::Ecs.options = {
  :associate_tag => ENV["AMZ_AFF_TAG"],
  :AWS_access_key_id => ENV["AMZ_AFF_KEY"],
  :AWS_secret_key => ENV["AMZ_AFF_SECRET"],
  :country => 'jp'
}

RakutenWebService.configuration do |c|
  c.application_id = ENV["RAKUTEN_APP_ID"]
  c.affiliate_id = ENV["RAKUTEN_AFF_ID"]
end

Yahoo::Api.configure do |options|
  options[:appid] = ENV["YAHOO_APP_ID"]
  options[:affiliate_type] = 'vc'
  options[:affiliate_id] = ENV["YAHOO_AFF_ID"]
end

