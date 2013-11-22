require 'spec_helper'

describe Authorization do
  let(:auth) { FactoryGirl.build(:authorization) }
  subject{ auth }
  it { should respond_to(:fetch_details_from_facebook) }
  it { should respond_to(:fetch_details_from_twitter) }

  it "fetch_details_from_twitter" do
    pending
  end

  it "fetch_details_from_facebook" do
    pending
  end
end
