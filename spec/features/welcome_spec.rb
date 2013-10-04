require'spec_helper'

feature 'welcome page' do
  scenario "visit welcome page" do
    visit root_path
    expect(page).to have_content "LookForwardTo.it"
  end
end
