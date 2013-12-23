require 'spec_helper'

feature 'users page' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_thing) { FactoryGirl.create(:thing, user: user) }
  let!(:thing1) { FactoryGirl.create(:thing) }
  let!(:thing2) { FactoryGirl.create(:thing) }
  let!(:like) { FactoryGirl.create(:vote, user: user, thing: thing1) }
  let!(:have) { FactoryGirl.create(:vote, user: user, thing: thing2, vote_type: "have") }
  let!(:comment) { FactoryGirl.create(:comment, user: user) }

  background do
    visit user_page_path user
  end

  scenario 'likes' do
    expect(page).to have_link("", href: thing_path(thing1))
  end

  scenario 'haves' do
    expect(page).to have_link("", href: thing_path(thing2))
  end

  scenario 'shared things' do
    expect(page).to have_link("", href: thing_path(user_thing))
  end

  scenario 'comments' do
    expect(page).to have_content comment.content
  end
end
