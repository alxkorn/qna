require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional infoto my question
  As a question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/alxkorn/26076b45ec43c8e4ea10bb5d32d1f7fc' }
  given(:google) { 'https://www.google.com' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'
    within page.all(:css, '.nested-fields')[1] do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Google', href: google
  end

  scenario 'User adds link when asks question with error', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'Add link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'invalid url'

    click_on 'Ask'

    expect(page).to have_content "Links url invalid url is invalid"
  end

end