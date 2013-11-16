require 'spec_helper'

describe Image do
  it { should respond_to(:url) }
  it { should respond_to(:normal_url) }
  it { should respond_to(:thumb_url) }
end
