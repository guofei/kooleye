require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  subject{ user }

  it { should respond_to(:email_view) }
  it { should respond_to(:virtual_mail?) }
  it { should respond_to(:bind_service) }
end
