# frozen_string_literal: true

require 'rails_helper'

feature "Authenticated User can answer question while being on question's page", "
In order to help someone to resolve the problem
As an authenticated user
I'd like to be able to answer question
" do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      within '.new-answer-form' do
        fill_in 'Body', with: 'Answer text'
      end

      click_on 'Submit answer'
      expect(page).to have_content 'Answer text'
    end

    scenario 'creates answer with attached files', js: true do
      within '.new-answer-form' do
        fill_in 'Body', with: 'Answer text'
      end

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Submit answer"

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'tries to answer the question with errors', js: true do
      click_on 'Submit answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Submit answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer-form' do
          fill_in 'Body', with: 'Answer text'
        end

        click_on 'Submit answer'
        expect(page).to have_content 'Answer text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer text'
      end
    end
  end
end
