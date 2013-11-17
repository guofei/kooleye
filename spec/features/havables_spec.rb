# -*- coding: utf-8 -*-
require "spec_helper"

feature 'havables' do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:user) { FactoryGirl.create(:user) }
  let(:havable) { FactoryGirl.build(:havable, user: user, thing: thing) }

  context 'as a guest' do
    background do
      visit thing_path(thing)
    end

    scenario 'read havables' do
      expect(page).to have_content("人が所有している")
    end

    scenario 'have' do
      click_link "have"
      expect(page).to have_content("Login")
    end
  end

  context 'as a user' do
    background do
      login_as user
      visit thing_path(thing)
    end

    scenario 'have' do
      expect{ click_link "have" }.to change(thing.havables, :count).by(1)
    end

    scenario 'have twice' do
      expect do
        click_link "have"
        click_link "have"
      end.to change(thing.havables, :count).by(1)
    end
  end
end