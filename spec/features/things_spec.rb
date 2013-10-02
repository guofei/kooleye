require 'spec_helper'

feature 'things' do
  scenario 'user can see all things' do
    thing = FactoryGirl.create(:thing)
    visit things_path
    pending
  end
end
