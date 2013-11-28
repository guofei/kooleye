require 'spec_helper'

feature 'thing/buy' do
  let(:thing) { FactoryGirl.create(:thing) }

  background do
    visit thing_path thing
  end

  scenario 'buy thing' do
    expect(page).to have_link("buy-btn")
  end
end
