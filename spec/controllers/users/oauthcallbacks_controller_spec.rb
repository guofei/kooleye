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
