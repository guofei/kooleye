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

    scenario 'add comment' do
      pending
      fill_in 'comment content', with:"test"
      click_button 'Comment'
      expect(page).to have_content("Sign")
    end
  end
end
