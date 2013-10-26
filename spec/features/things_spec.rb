require 'spec_helper'

feature 'things' do
  let(:thing) { thing = FactoryGirl.create(:thing) }
  let(:user) { thing = FactoryGirl.create(:user) }
  context 'as a guest' do
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
      expect(page).to have_content("Sign")
    end
  end

  context 'as a user' do
    background do
      login_as user
    end
    scenario 'shares a new thing' do
      visit new_thing_path
      fill_in 'Name', with: thing.name
      fill_in 'Summary', with: thing.summary
      fill_in 'Introduction', with: thing.introduction
      attach_file 'thing_images_attributes_0_file', File.join(Rails.root, '/spec/factories/files/image.png')
      attach_file 'thing_images_attributes_1_file', File.join(Rails.root, '/spec/factories/files/image.png')
      click_button 'Create Thing'
      expect(page).to have_content(thing.introduction)
    end
    scenario 'adds a comment'
  end
end
