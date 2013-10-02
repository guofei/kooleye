require'spec_helper'

feature 'welcome' do
  scenario "visit welcome page" do
    visit root_path
    expect(page).to have_content "welcome"
  end
end
