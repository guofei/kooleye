class User < ActiveRecord::Base
  extend OmniauthCallbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_many :things, -> { order(updated_at: :desc) }
  has_many :authorizations, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :votes, -> { order(updated_at: :desc) }, :dependent => :destroy
  has_many :helpfulnesses, :dependent => :destroy

  def votes_by(type)
    votes.select{|v| v.vote_type == type.to_s }
  end

  def bind_service(response)
    provider = response["provider"]
    uid = response["uid"]
    token = response["credentials"]["token"]
    secret = response["credentials"]["secret"]
    authorizations.create(provider: provider , uid: uid, token: token, secret: secret)
  end

  def virtual_mail?
    email.include? "@twitter.com"
  end

  def email_view
    return "" if virtual_mail?
    return email
  end

  def send_to_facebook(msg, page_title, page_url)
    return if get_auth(:facebook).blank?
    begin
      client = get_auth("facebook").facebook_client
      client.put_wall_post(ActionController::Base.helpers.strip_tags(msg), {name: page_title, link: page_url}) if client
    rescue Koala::KoalaError => e
      p e
    end
  end

  def send_to_twitter(msg, url)
    return if get_auth(:twitter).blank?
    begin
      client = get_auth("twitter").twitter_client
      client.update(ActionController::Base.helpers.strip_tags(msg)[0, 100] + " " + url) if client
    rescue Twitter::Error => e
      p e
    end
  end

  def get_auth(provider)
    authorizations.reverse_each do |auth|
      return auth if auth.provider == provider.to_s
    end
    return nil
  end

  def set_profile(name, url, image)
    self.name = name if self.name.blank? && !name.blank?
    self.url = url if self.url.blank? && !url.blank?
    self.image = image if self.image.blank? && !image.blank?
    save
  end
end
