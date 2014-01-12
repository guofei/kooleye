# -*- coding: utf-8 -*-
require 'spec_helper'

feature 'comments' do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:user) { FactoryGirl.create(:user) }
  let!(:comment) { FactoryGirl.create(:comment, thing: thing, user: user) }
  context 'as a guest' do
    background do
      visit thing_path(thing)
    end

    scenario 'reads all comments' do
      expect(page).to have_content(comment.content)
    end

    scenario 'read comment' do
      expect(page).to have_link(comment.user.name, href: user_page_path(comment.user))
    end

    scenario 'add comment' do
      fill_in 'comment_content', with:"test"
      click_button I18n.t('view.comment.submit')
      expect(page).to have_content(I18n.t("shared.login"))
    end
  end

  context 'as a user' do
    background do
      login_with_facebook user
      visit thing_path(thing)
    end

    scenario 'add comment' do
      fill_in 'comment_content', with: "thank you very much kaku"
      click_button I18n.t('view.comment.submit')
      expect(page).to have_content("thank you very much kaku")
    end

    scenario 'thanks to a comment' do
      expect(page).to have_content("参考になった")
      expect{ first('.helpful').click }.to change{ Helpfulness.count }.by(1)
    end
  end
end
