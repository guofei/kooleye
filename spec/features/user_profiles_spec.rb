# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'profile' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:thing) { FactoryGirl.create(:thing) }
  let!(:like) { FactoryGirl.create(:vote, user: user, thing: thing) }
  let!(:have) { FactoryGirl.create(:vote, user: user, thing: thing, vote_type: "have") }

  context 'welcome page' do
    background do
      visit root_path
    end

    context 'as guest' do
      scenario 'show likes' do
        expect(page).not_to have_content I18n.t('view.user.current_like')
      end

      scenario 'show haves' do
        expect(page).not_to have_content I18n.t('view.user.current_have')
      end
    end

    context 'as a vote user' do
      background do
        login_with_facebook user
        visit root_path
      end
      scenario 'show likes' do
        expect(page).to have_content I18n.t('view.user.current_like')
      end

      scenario 'show haves' do
        expect(page).to have_content I18n.t('view.user.current_have')
      end
    end

    context 'as a not vote user' do
      background do
        user2 =  FactoryGirl.create(:user)
        login_with_facebook user2
        visit root_path
      end
      scenario 'not like info' do
        expect(page).to have_content I18n.t('view.user.no_like')
      end
      scenario 'not have info' do
        expect(page).to have_content I18n.t('view.user.no_have')
      end
    end
  end
end
