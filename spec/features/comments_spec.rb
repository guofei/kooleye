require 'spec_helper'

feature 'comments' do
  let(:thing) { FactoryGirl.create(:thing) }
  let(:user) { FactoryGirl.create(:user) }
  let(:comment) { FactoryGirl.create(:comment, thing: thing, user: user) }
  context 'as a guest' do
    scenario 'reads all comments' do
      comment
      visit thing_path(thing)
      expect(page).to have_content(comment.content)
    end
  end
end
