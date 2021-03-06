require 'spec_helper'

describe Vote do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:user) { FactoryGirl.create(:user) }
  let(:like) { FactoryGirl.build(:vote, user: user, thing: thing) }
  subject{ like }

  it { should respond_to(:duplication?) }

  describe "duplication?" do
    context "when user had liked" do
      let!(:liked) { FactoryGirl.create(:vote, user: user, thing: thing) }
      it "duplication" do
        expect(like.duplication?).to be_true
      end
    end

    context "when user have not liked" do
      it "not duplication" do
        expect(like.duplication?).to be_false
      end
    end
  end
end
