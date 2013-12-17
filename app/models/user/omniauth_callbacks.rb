class User
  module OmniauthCallbacks
    def from_omniauth(auth, current_user)
      authorization = Authorization.where(:provider => auth["provider"], :uid => auth["uid"].to_s, :token => auth["credentials"]["token"], :secret => auth["credentials"]["secret"]).first_or_initialize
      if authorization.user.blank?
        if auth["provider"] == "twitter"
          user = current_user.nil? ? Authorization.where(:provider => auth["provider"], :uid => auth["uid"].to_s).first_or_initialize.user : current_user
        else
          email = auth["info"]["email"]
          user = current_user.nil? ? User.where('email = ?', email).first : current_user
        end
        if user.blank?
          user = new_from_provider_data(auth["provider"], auth["uid"], auth["info"])
          user.save(:validate => false)
        end
        authorization = user.bind_service(auth)
      end
      authorization.user
    end

    private
    def new_from_provider_data(provider, uid, data)
      User.new do |user|
        user.name = data["name"]
        user.email = data["email"]
        user.url = data["urls"][provider.capitalize]
        user.url = data["urls"]["Google"] if provider.to_s == "google_oauth2"
        user.image = data["image"]
        if provider == "twitter"
          user.name = data["nickname"]
          user.email = twitter_uid_to_email(uid)
        end
        user.password = Devise.friendly_token[0, 20]
      end
    end

    def twitter_uid_to_email(uid)
      "twitter+#{uid}@twitter.com"
    end
  end
end
