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
end
