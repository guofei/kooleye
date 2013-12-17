# -*- coding: utf-8 -*-
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @user = User.from_omniauth request.env["omniauth.auth"], current_user
    if @user.persisted?
      flash[:notice] = "Signed in with #{request.env["omniauth.auth"]["provider"]} successfully."
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to new_user_registration_url
    end
  end

  def failure
    #handle you logic here..
    #and delegate to super.
    super
  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all
  alias_method :twitter, :all

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
end
