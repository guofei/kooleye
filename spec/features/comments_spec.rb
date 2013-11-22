require 'spec_helper'

feature 'comments' do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:user) { FactoryGirl.create(:user) }
  let(:comment) { FactoryGirl.create(:comment, thing: thing, user: user) }
  context 'as a guest' do
    background do
      comment
      visit thing_path(thing)
    end

    scenario 'reads all comments' do
      expect(page).to have_content(comment.content)
    end

    scenario 'read comment' do
      expect(page).to have_link(comment.user.name, href: comment.user.url)
    end

    scenario 'add comment' do
      fill_in 'comment_content', with:"test"
      click_button 'Create Comment'
      expect(page).to have_content("Login")
    end
  end

  context 'as a user' do
    background do
      login_with_facebook user
      visit thing_path(thing)
    end

    scenario 'add comment' do
      fill_in 'comment_content', with: "thank you very much kaku"
      click_button 'Create Comment'
      expect(page).to have_content("thank you very much kaku")
    end
  end
end
