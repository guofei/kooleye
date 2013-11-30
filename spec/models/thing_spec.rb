require 'spec_helper'

describe Thing do
  let(:user) { FactoryGirl.create(:user) }
  let(:thing) { FactoryGirl.build(:thing) }
  subject{ thing }

  it { should respond_to(:other_things) }
  it { should respond_to(:youtube_id) }
  it { should respond_to(:generate_token) }
  it { should respond_to(:token) }

  describe "token" do
    it "generate token" do
      random_token = thing.generate_token
      expect(random_token.size).to be > 0
      expect(random_token).to eq thing.token
    end
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

  describe "youtube it" do
    context "www.youtube.com/watch?v=id" do
      before{ thing.video = "www.youtube.com/watch?v=id" }
      its(:youtube_id) { should eq("id") }
    end
    context "youtu.be/id" do
      before{ thing.video = "youtu.be/id" }
      its(:youtube_id) { should eq("id") }
    end
    context "noid" do
      before{ thing.video = "" }
      its(:youtube_id) { should be_nil }
    end
  end
end
