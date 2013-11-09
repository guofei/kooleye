class User
  module OmniauthCallbacks
    def from_omniauth(auth, current_user)
      authorization = Authorization.where(:provider => auth["provider"], :uid => auth["uid"].to_s, :token => auth["credentials"]["token"], :secret => auth["credentials"]["secret"]).first_or_initialize
      if authorization.user.blank?
        user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
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
        if provider == "twitter"
          user.name = data["nickname"]
          user.email = "twitter+#{uid}@twitter.com"
        end
        user.password = Devise.friendly_token[0, 20]
      end
    end
  end
end
