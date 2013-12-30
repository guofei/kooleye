# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'User' do
  let(:user) { FactoryGirl.create(:user) }

  context "as a guest" do
    scenario 'email alert' do
      visit root_path
      expect(page).not_to have_content "まもなく登録完了です"
    end
  end

  context "as a user" do
    background do
      login_with_facebook user
    end

    scenario 'email alert' do
      user.email = "abc@twitter.com"
      user.save
      visit root_path
      expect(page).to have_content "まもなく登録完了です"
    end
  end
end
