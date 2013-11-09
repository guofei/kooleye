# -*- coding: utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @user = User.from_omniauth request.env["omniauth.auth"], current_user
    if @user.persisted?
      flash[:notice] = "Signed in with #{request.env["omniauth.auth"]["provider"]} successfully."
      sign_in @user, :event => :authentication
      if @user.virtual_mail?
        redirect_to edit_user_registration_path
      else
        sign_in_and_redirect @user
      end
    else
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :all
  alias_method :twitter, :all
end
