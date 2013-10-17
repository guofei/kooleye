require 'spec_helper'

describe Users::OmniauthCallbacksController, "handle facebook authentication callback" do
  let(:user) { FactoryGirl.create(:user) }
  describe "#annonymous user" do
    before(:each) do
      stub_env_for_omniauth
      User.stub(:find_or_create_for_facebook).and_return(user)
    end

    it "create a new user" do
      User.should_receive(:find_or_create_for_facebook)
      get :facebook
    end

    #it { response.should redirect_to @user }
  end

  describe "#logged in user" do
    before(:each) do
      stub_env_for_omniauth
      controller.stub(:current_user).and_return(user)
    end

    it "create a new authentication" do
      user.should_receive(:bind_service)
      get :facebook
    end

    #it { response.should redirect_to root_path }
  end
end

def stub_env_for_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                  "provider" => "facebook",
                                                                  "uid" => "1234",
                                                                  "info" => { "nickname" => "fb", "email" => "ghost@nobody.com" }
                                                                   })
  request.env["devise.mapping"] = Devise.mappings[:user]
  request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
end
