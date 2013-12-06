# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'votes' do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:user) { FactoryGirl.create(:user) }
  let(:like) { FactoryGirl.build(:vote, user: user, thing: thing) }

  context 'as a guest' do
    background do
      visit thing_path(thing)
    end

    scenario 'like' do
      click_link "like"
      expect(page).to have_content(I18n.t("shared.login"))
    end
  end

  context 'as a user' do
    background do
      login_with_facebook user
      visit thing_path(thing)
    end

    scenario 'like' do
      expect{ click_link "like" }.to change(thing.votes, :count).by(1)
    end

    scenario 'like twice' do
      expect do
        click_link "like"
        click_link "like"
      end.to change(thing.votes, :count).by(1)
    end

    scenario 'like and have' do
      expect do
        click_link "like"
        click_link "have"
      end.to change(thing.votes, :count).by(2)
    end

    scenario 'like and have twice' do
      expect do
        click_link "like"
        click_link "have"
        click_link "have"
      end.to change(thing.votes, :count).by(2)
    end
  end
end
