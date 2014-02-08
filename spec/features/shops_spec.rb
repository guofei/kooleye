require 'spec_helper'

feature 'shops' do
  let!(:thing) { FactoryGirl.create(:thing) }

  scenario 'visit shops' do
    visit shops_path
    expect(page).to have_xpath("//input[@id='search']")
  end
end
