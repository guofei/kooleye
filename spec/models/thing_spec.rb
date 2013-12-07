require 'spec_helper'

describe Thing do
  let(:user) { FactoryGirl.create(:user) }
  let(:thing) { FactoryGirl.build(:thing) }
  subject{ thing }

  it { should respond_to(:other_things) }
  it { should respond_to(:has_video?) }
  it { should respond_to(:generate_token) }
  it { should respond_to(:token) }
  it { should respond_to(:count_by) }

  describe "count by" do
    before do
      thing.save
      FactoryGirl.create(:vote, user: user, thing: thing)
      FactoryGirl.create(:vote, user: user, thing: thing)
      FactoryGirl.create(:vote, user: user, thing: thing, vote_type: "have")
    end
    it "count by like" do
      expect(thing.votes.count).to eq 3
      expect(thing.count_by(:like)).to eq 2
    end
    it "count by have" do
      expect(thing.count_by(:have)).to eq 1
    end
  end

  it "generate token" do
    random_token = thing.generate_token
    expect(random_token.size).to be > 0
    expect(random_token).to eq thing.token
  end

  describe "when name is not present" do
    before { thing.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { thing.name = "a" * 31 }
    it { should_not be_valid }
  end

  describe "when summary is not present" do
    before { thing.summary = " " }
    it { should_not be_valid }
  end

  describe "when introduction is not present" do
    before { thing.introduction = " " }
    it { should_not be_valid }
  end

  describe "when introduction is too short" do
    before { thing.introduction = "a" * 19 }
    it { should_not be_valid }
  end

  describe "ohter things" do
    before do
      thing.user = user
      thing.save
      another = FactoryGirl.create(:thing, user: user)
    end
    its("other_things.size") { should eq 2 }
  end

  describe "has video?" do
    context "youtube" do
      before{ thing.video = "http://www.youtube.com/watch?v=h4B5vtaAGN0" }
      its(:has_video?) { should be_true }
    end
    context "youtu.be" do
      before{ thing.video = "http://youtu.be/h4B5vtaAGN0" }
      its(:has_video?) { should be_true }
    end
    context "vimeo" do
      before{ thing.video = "http://vimeo.com/80605992" }
      its(:has_video?) { should be_true }
    end
    context "no video" do
      before{ thing.video = "" }
      its(:has_video?) { should be_false }
    end
  end
end
