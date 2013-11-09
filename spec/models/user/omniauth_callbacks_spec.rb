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
    expect(User.from_omniauth response_args(user, authorization), nil).to eq(user)
  end

  it "should bind serveice for user" do
    u = User.from_omniauth response_args(not_bind_user, auth), not_bind_user
    expect(u.authorizations.first.user).to eq(not_bind_user)
  end

  it "shoule create a user" do
    guest = FactoryGirl.build(:user)
    u = User.from_omniauth response_args(guest, auth), nil
    expect(u.email).to eq(guest.email)
    expect(User.find(u).email).to eq(guest.email)
  end
end

def response_args(user, auth)
  args = {"provider" => auth.provider,
    "uid" => auth.uid,
    "info" => { "nickname" => "fb", "email" => user.email },
    "credentials" => {"token" => "fdsf", "secret" => "fdsfsdfsf"}
  }
end
