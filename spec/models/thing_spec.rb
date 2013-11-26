require 'spec_helper'

describe Thing do
  let(:user) { FactoryGirl.create(:user) }
  let(:thing) { FactoryGirl.build(:thing) }
  subject{ thing }

  it { should respond_to(:other_things) }
  it { should respond_to(:youtube_id) }

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
    context "www.youtube.com/watch?v=123abc" do
      before{ thing.video = "www.youtube.com/watch?v=123abc" }
      its(:youtube_id) { should eq("123abc") }
    end
    context "youtu.be/123abc" do
      before{ thing.video = "youtu.be/123abc" }
      its(:youtube_id) { should eq("123abc") }
    end
    context "noid" do
      before{ thing.video = "" }
      its(:youtube_id) { should be_nil }
    end
  end
end
