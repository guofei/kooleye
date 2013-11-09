require 'spec_helper'

describe Users::OmniauthCallbacksController, "handle facebook authentication callback" do
  let(:user) { FactoryGirl.create(:user) }
  describe "#annonymous user" do
    before(:each) do
      stub_env_for_omniauth
      User.stub(:from_omniauth).and_return(user)
    end

    it "create or find a user" do
      User.should_receive(:from_omniauth)
      get :facebook
      expect(response.status).to eq(302)
    end
  end
end

def stub_env_for_omniauth
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                  "provider" => "facebook",
                                                                  "uid" => "1234",
                                                                  "info" => { "name" => "name", "nickname" => "fb", "email" => "ghost@nobody.com" },
                                                                  "credentials" => {"token" => "fdsf", "secret" => "fdsfsdfsf"}
                                                                   })
  request.env["devise.mapping"] = Devise.mappings[:user]
  request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
end
