class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(*providers)
    providers.each do |provider|
      define_method provider do
        if not current_user.blank?
          current_user.bind_service(request.env["omniauth.auth"]) #Add an auth to existing
          redirect_to root_path, :notice => "Binding #{provider} successfully."
        else
          @user = User.send "find_or_create_for_#{provider}", request.env["omniauth.auth"]
          if @user.persisted?
            flash[:notice] = "Signed in with #{provider.to_s.titleize} successfully."
            sign_in_and_redirect @user, :event => :authentication, :notice => "Login successfully" #FIXME
          else
            redirect_to new_user_registration_url
          end
        end
      end
    end
  end

  provides_callback_for :facebook, :twitter
end
