require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my question
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/alxkorn/26076b45ec43c8e4ea10bb5d32d1f7fc' }

  scenario 'User adds link when give answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Answer text'

    fill_in 'Link name', with:'My gist' 
    fill_in 'Url', with: gist_url


    click_on 'Submit answer'

    within '.answers_list' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end