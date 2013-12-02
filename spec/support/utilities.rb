# -*- coding: utf-8 -*-
def login_as(user)
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def login_by_webkit(user)
  visit new_user_session_path
  click_link_or_button 'Kooleye IDでログイン'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_link_or_button 'kooleye-id-sign-in'
end

def login_with_facebook_by_webkit(user)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(response_args "facebook", "123", user.name, user.email)
  visit new_user_session_path
  click_link_or_button 'Connect with Facebook'
end

def login_with_facebook(user)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(response_args "facebook", "123", user.name, user.email)
  visit root_path
  click_link_or_button 'facebook-login'
end

def stub_env_for_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(response_args)
  request.env["devise.mapping"] = Devise.mappings[:user]
  request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
end

def response_args(provider = "facebook", uid = "1234", name = "test", email = "test@email.com")
  args = {
    "provider" => provider,
    "uid" => uid,
    "info" => { "name" => name,
      "image"=>"http://graph.facebook.com/100003537136773/picture?type=square",
      "urls"=> {"Facebook"=>"https://www.facebook.com/upthings"},
      "nickname" => "fb",
      "email" => email },
    "credentials" => {"token" => "fdsf", "secret" => "fdsfsdfsf"}
  }
end
