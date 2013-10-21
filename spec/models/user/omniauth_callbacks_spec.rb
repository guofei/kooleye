require 'spec_helper'

describe User::OmniauthCallbacks do
  let(:user) { FactoryGirl.create(:user) }
  let!(:authorization) { FactoryGirl.create(:authorization, user: user ) }
  let(:guest) { FactoryGirl.build(:user) }

  it "should response to :find_or_create_for_twitter" do
    expect(User).to respond_to(:find_or_create_for_twitter)
  end

  it "should response to :find_or_create_for_facebook" do
    expect(User).to respond_to(:find_or_create_for_facebook)
  end

  it "should find the user" do
    expect(User.find_or_create_for_facebook(response_args user)).to eq(user)
  end

  it "shoule create a user" do
    u = User.find_or_create_for_facebook(response_args guest)
    expect(u.email).to eq(guest.email)
    expect(User.find(u).email).to eq(guest.email)
  end
end

def response_args(user)
  args = {"provider" => user.authorizations.first.try(:provider),
    "uid" => user.authorizations.first.try(:uid),
    "info" => { "nickname" => "fb", "email" => user.email }
  }
end
