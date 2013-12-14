require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:user2) { FactoryGirl.build(:user) }
  subject{ user }

  it { should respond_to(:email_view) }
  it { should respond_to(:virtual_mail?) }
  it { should respond_to(:bind_service) }
  it { should respond_to(:set_profile) }
  it { should respond_to(:send_to_facebook) }
  it { should respond_to(:send_to_twitter) }
  it { should respond_to(:votes_by)}

  it "get auth" do
    user.save
    fb = FactoryGirl.build(:authorization, user: user)
    fb.provider = "facebook"
    fb.save
    twi = FactoryGirl.build(:authorization, user: user)
    twi.provider = "twitter"
    twi.save
    expect(user.get_auth("facebook")).to eq fb
    expect(user.get_auth("twitter")).to eq twi
  end

  it "set profile" do
    user.name = nil
    user.url = nil
    user.image = nil
    user.save
    user.set_profile(user2.name, user2.url, user2.image)
    expect(user.name).to eq(user2.name)
    expect(user.url).to eq(user2.url)
    expect(user.image).to eq(user2.image)
  end

  describe 'vote by' do
    let!(:vote_user) { FactoryGirl.create(:user) }
    let!(:like) { FactoryGirl.create(:vote, user: vote_user) }
    let!(:have) { FactoryGirl.create(:vote, user: vote_user, vote_type: "have") }
    it "votes by like" do
      expect(vote_user.votes_by(:like)[0]).to eq like
    end
    it "votes by have" do
      expect(vote_user.votes_by(:have)[0]).to eq have
    end
  end
end
