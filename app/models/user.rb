class User < ActiveRecord::Base
  extend OmniauthCallbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_many :authorizations, :dependent => :destroy
  has_many :things
  has_many :comments
  has_many :likes
  has_many :havables

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
end
