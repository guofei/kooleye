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

  validates :name, presence: true

  def bind_service(response)
    provider = response["provider"]
    uid = response["uid"]
    authorizations.create(:provider => provider , :uid => uid )
  end

  def virtual_mail?
    email.include? "@twitter.com"
  end

  def email_view
    if virtual_mail?
      return ""
    else
      return email
    end
  end
end
