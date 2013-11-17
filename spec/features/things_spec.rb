require 'spec_helper'

feature 'things' do
  let(:thing) { FactoryGirl.create(:thing) }
  context 'as a guest' do
    scenario 'reads all things' do
      thing
      visit things_path
      expect(page).to have_content thing.name
    end

    scenario 'reads a thing' do
      visit thing_path(thing)
      expect(page).to have_content thing.name
      expect(page).to have_content thing.summary
      expect(page).to have_content thing.introduction
    end

    scenario 'login as facebook' do
      facebook_user = FactoryGirl.build(:user)
      visit root_path
      login_with_facebook facebook_user
      expect(page).to have_content(facebook_user.name)
    end

    scenario 'share a new thing' do
      visit new_thing_path
      expect(page).to have_content("Sign")
    end
  end

  context 'as a user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:newthing) { FactoryGirl.build(:thing) }
    background do
      login_as user
      visit new_thing_path
    end

    scenario 'add a image' do
      attach_file 'image_file', File.join(Rails.root, '/spec/factories/files/image.png')
      #expect{ click_button 'Create Image' }.to change(Image, :count)
    end

    scenario 'shares a new thing' do
      fill_in 'Name', with: newthing.name
      fill_in 'Summary', with: newthing.summary
      fill_in 'Introduction', with: newthing.introduction
      fill_in 'Video', with: newthing.video
      expect{ click_button 'Create Thing' }.to change(Thing, :count)
      expect(page).to have_content(newthing.introduction)
      expect(page).to have_selector("iframe[src=\"#{newthing.video}\"]")
    end
  end
end
