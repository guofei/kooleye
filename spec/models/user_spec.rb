require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:user2) { FactoryGirl.build(:user) }
  subject{ user }

  it { should respond_to(:email_view) }
  it { should respond_to(:virtual_mail?) }
  it { should respond_to(:bind_service) }
  it { should respond_to(:set_profile) }
  describe "set proflie" do
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
  end
end
