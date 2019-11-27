# frozen_string_literal: true

require 'rails_helper'

feature "User can answer question while being on question's page", "
In order to help someone to resolve the problem
As a user
I'd like to be able to answer question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    # sign_in(user)
    visit question_path(question)
  end

  scenario 'answers the question' do
    fill_in 'Body', with: 'Answer text'

    click_on 'Submit answer'
    expect(page).to have_content 'Answer text'
  end

  scenario 'tries to answer the question with errors' do
    click_on 'Submit answer'
    expect(page).to have_content "Body can't be blank"
  end

  # scenario 'Unauthenticated user tries to answer the question' do
  #   # visit question_path(question)
  #   click_on 'Submit answer'

  #   expect(page).to have_content ''
  # end
end
