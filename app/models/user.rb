class User < ActiveRecord::Base
  extend OmniauthCallbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_many :things
  has_many :authorizations, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :havables, :dependent => :destroy

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

  def send_to_facebook(msg, title, url)
    begin
      client = authorizations.last.facebook_client
      client.put_wall_post(msg, {name: title, link: url}) if client
    rescue Koala::KoalaError => e
      p e
    end
  end

  def send_to_twitter(msg)
    begin
      client = authorizations.last.twitter_client
      client.update(msg) if client
    rescue Twitter::Error => e
      p e
    end
  end

  def send_facebook

  end

  def set_profile(name, url, image)
    self.name = name if self.name.blank?
    self.url = url if self.url.blank?
    self.image = image if self.image.blank?
    save
  end
end
