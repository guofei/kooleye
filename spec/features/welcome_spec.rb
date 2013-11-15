require'spec_helper'

feature 'welcome page' do
  let!(:hot_thing) { FactoryGirl.create(:thing) }
  let!(:new_thing) { FactoryGirl.create(:thing) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:like) { FactoryGirl.create(:like, user: user, thing: hot_thing) }

  background { visit root_path }

  scenario "visit welcome page" do
    expect(page).to have_content "LookForwardTo.it"
  end

  scenario "hot thing" do
    expect(page).to have_content(hot_thing.name)
  end

  scenario "new things" do
    expect(page).to have_content(new_thing.name)
  end
end
