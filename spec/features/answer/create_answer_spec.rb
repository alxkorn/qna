# frozen_string_literal: true

require 'rails_helper'

feature "Authenticated User can answer question while being on question's page", "
In order to help someone to resolve the problem
As an authenticated user
I'd like to be able to answer question
" do
  given(:question) { create(:question) }
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
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
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Submit answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
