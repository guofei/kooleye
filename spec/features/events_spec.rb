require 'spec_helper'

feature 'event' do
  let!(:event) { FactoryGirl.create(:event) }

  scenario "welcome page event" do
    visit root_path
    expect(page).to have_content event.summary
  end

  scenario "event show" do
    visit event_path(event)
    expect(page).to have_content event.content
  end
end
