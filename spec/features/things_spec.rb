require 'spec_helper'

feature 'things' do
  context 'as a guest or user' do
    let(:thing) { thing = FactoryGirl.create(:thing) }
    scenario 'reads all things' do
      thing
      visit things_path
      expect(page).to have_content thing.name
    end

    scenario 'reads a thing' do
      visit thing_path(thing)
    end

    scenario 'share a new thing' do
      visit new_thing_path
      pending
      expect(response).to redirct_to root_path
    end
  end

  context 'as a user' do
    scenario 'shares a new thing' do
      pending
    end
    scenario 'adds a comment'
  end
end
