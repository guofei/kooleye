require 'spec_helper'

describe User::OmniauthCallbacks do
  let!(:user) { FactoryGirl.create(:user) }
  let(:not_bind_user) { FactoryGirl.create(:user) }
  let!(:authorization) { FactoryGirl.create(:authorization, user: user) }
  let!(:auth) { FactoryGirl.create(:authorization) }

  it "should response to :from_omniauth" do
    expect(User).to respond_to(:from_omniauth)
  end

  it "should find the user" do
    expect(User.from_omniauth response_args(authorization.provider, authorization.uid, user.name, user.email), nil).to eq(user)
  end

  it "should bind serveice for user" do
    u = User.from_omniauth response_args(auth.provider, auth.uid, not_bind_user.name, not_bind_user.email), not_bind_user
    expect(u.authorizations.first.user).to eq(not_bind_user)
  end

  it "shoule create a user" do
    guest = FactoryGirl.build(:user)
    u = User.from_omniauth response_args(auth.provider, auth.uid, guest.name, guest.email), nil
    expect(u.email).to eq(guest.email)
    expect(User.find(u).email).to eq(guest.email)
  end
end
