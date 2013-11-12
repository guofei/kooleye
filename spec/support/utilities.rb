def login_as(user)
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def login_with_facebook(user)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                  "provider" => "facebook",
                                                                  "uid" => "1234",
                                                                  "info" => { "name" => user.name, "nickname" => "fb", "email" => user.email },
                                                                  "credentials" => {"token" => "fdsf", "secret" => "fdsfsdfsf"}
                                                                   })
  visit root_path
  click_link_or_button 'Facebook'
end
