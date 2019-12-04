# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his own answer', "
As an authenticated user
I'd like to be able to felete my own question
" do
  given(:user) { create(:user) }
  given(:answer) { create(:answer, user: user) }
  given(:answer_not_owned) { create(:answer) }

  describe 'Authenticated user' do
  
    background { sign_in(user) }

    scenario 'deletes his own answer', js: true do
      visit question_path(answer.question)
      within('div', class: 'answer_box', text: answer.body) { click_on 'Delete' }

      expect(page).to have_content 'Your answer was deleted'
      expect(page.find('div', class: 'answers_list', visible: false)).to_not have_content answer.body
    end

    scenario 'tries to delete not his own answer', js: true do
      visit question_path(answer_not_owned.question)

      expect(page.find('div', class: 'answer_box', text: answer_not_owned.body)).to_not have_link('Delete')
    end
  end

  scenario 'Unanthenticated user tries to delete answer', js: true do
    visit question_path(answer.question)

    expect(page.find('div', class: 'answer_box', text: answer.body)).to_not have_link('Delete')
  end
end
