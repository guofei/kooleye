require 'spec_helper'

feature 'things' do
  scenario 'user can see all things' do
    thing = FactoryGirl.create(:thing)
    visit things_path
    expect(page).to have_content thing.name
  end
end
