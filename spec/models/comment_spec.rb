require 'spec_helper'

describe Comment do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:comment) {FactoryGirl.build(:comment, thing: thing)}

  it { should respond_to :short_content }

  describe "short content" do
    it "content size less than length" do
      comment.content = "a" * 100
      expect(comment.short_content.size).to be < 60
    end
  end
  describe "when thing_id is not present" do
    before { comment.thing = nil }
    it { should_not be_valid }
  end
  describe "when content is not present" do
    before { comment.content = nil }
    it { should_not be_valid }
  end
end
