require 'spec_helper'

describe Thing do
  let(:thing) { FactoryGirl.build(:thing) }
  subject{ thing }

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

  describe "youtube it" do
    it { should respond_to(:youtube_id) }
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
