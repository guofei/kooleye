class Authorization < ActiveRecord::Base
  belongs_to :user

  after_create :fetch_details

  def fetch_details
    self.send("fetch_details_from_#{self.provider.downcase}")
  end

  def fetch_details_from_facebook
    return if self.token.blank?
    begin
      graph = facebook_client
      fbdata = graph.get_object("me")
      self.user.set_profile fbdata['name'], fbdata['link'], "https://graph.facebook.com/" + fbdata['id'] + "/picture?type=square"
      if not graph.debug_token(self.token)["data"]["scopes"].include? "publish_stream"
        set_token_nil
        return
      end
    rescue Koala::KoalaError => e
      p e
      set_token_nil
    end
  end

  def fetch_details_from_twitter
    return if self.token.blank? or self.secret.blank?
    begin
      twitter = twitter_client
      self.user.set_profile twitter.user.user_name.to_s, twitter.user.url.to_s, twitter.user.profile_image_uri_https.to_s
    rescue Twitter::Error => e
      p e
      set_token_nil
    end
  end

  def fetch_details_from_google_oauth2
  end

  def twitter_client
    return nil if provider != 'twitter'
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_APP_ID']
      config.consumer_secret     = ENV['TWITTER_APP_SECRET']
      config.access_token        = self.token
      config.access_token_secret = self.secret
    end
  end

  def facebook_client
    return nil if provider != 'facebook'
    Koala::Facebook::API.new(self.token)
  end

  private
  def set_token_nil
    self.token = nil
    self.secret = nil
    self.save
  end
end
