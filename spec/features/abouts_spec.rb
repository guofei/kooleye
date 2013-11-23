require 'spec_helper'

feature 'about' do
  let(:about) { FactoryGirl.create(:about) }

  scenario 'read about' do
    visit about_path(about)
    expect(page).to have_content(about.content)
  end
end
