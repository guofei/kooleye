# -*- coding: utf-8 -*-
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
      expect(page).to have_link thing.user.name, href: thing.user.url
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
      login_by_webkit user
      visit new_thing_path
    end

    scenario 'add a image', js: true do
      script = "$('#image_file').show();"
      script << "$('#image-upload-submit').show();"
      page.driver.browser.execute_script(script)
      attach_file 'image_file', File.join(Rails.root, '/spec/factories/files/image.png')
      pending
    end

    scenario 'shares a new thing', js: true do
      pending
      script = "$('#image_file').show();"
      page.driver.browser.execute_script(script)
      attach_file 'image_file', File.join(Rails.root, '/spec/factories/files/image.png')
      script = "$('#new_image').submit();"
      page.driver.browser.execute_script(script)
      script = "$('#thing_introduction').val(new Array(200).join('a '));"
      page.driver.browser.execute_script(script)
      fill_in 'Name', with: newthing.name
      fill_in 'Summary', with: newthing.summary
      fill_in 'Video', with: newthing.video
      I18n.locale = :ja
      expect{ click_link_or_button I18n.t('helpers.submit.create') }.to change(Thing, :count)
      expect(page).to have_content(newthing.introduction)
      expect(page).to have_selector("iframe[src=\"#{newthing.video}\"]")
    end
  end
end
