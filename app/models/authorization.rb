class Authorization < ActiveRecord::Base
  belongs_to :user

  after_create :fetch_details

  def fetch_details
    self.send("fetch_details_from_#{self.provider.downcase}")
  end

  def fetch_details_from_facebook
    return if self.token.blank?
    begin
      graph = Koala::Facebook::API.new(self.token)
      fbdata = graph.get_object("me")
      self.user.name = fbdata['name'] if self.user.name.blank?
      self.user.url = fbdata['link'] if self.user.url.blank?
      self.user.image = "http://graph.facebook.com/" + fbdata['id'] + "/picture?type=square" if self.user.image.blank?
      self.user.save
    rescue
      self.token = nil
      self.secret = nil
      self.save
    end
  end

  def fetch_details_from_twitter
    return if self.token.blank? or self.secret.blank?
    begin
      twitter = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_APP_ID']
        config.consumer_secret     = ENV['TWITTER_APP_SECRET']
        config.access_token        = self.token
        config.access_token_secret = self.secret
      end
      self.user.name = twitter.user.user_name.to_s if self.user.name.blank?
      self.user.url = twitter.user.url.to_s if self.user.url.blank?
      self.user.image = twitter.user.profile_image_uri.to_s if self.user.image.blank?
      self.user.save
    rescue
      self.token = nil
      self.secret = nil
      self.save
    end
  end
end
