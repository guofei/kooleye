class User
  module OmniauthCallbacks
    ["facebook","twitter"].each do |provider|
      define_method "find_or_create_for_#{provider}" do |response|
        uid = response["uid"]
        data = response["info"]

        if user = Authorization.where("provider" => provider , "uid" => uid).first.try(:user)
          user
        elsif user = User.find_by_email(data["email"])
          user.bindp_service(response)
          user
        else
          user = new_from_provider_data(provider, uid, data)

          if user.save(:validate => false)
            user.authorizations << Authorization.new(provider: provider, uid: uid )
            return user
          else
            Rails.logger.warn("Error: User.create_from_hash, #{user.errors.inspect}")
            return nil
          end
        end
      end
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
