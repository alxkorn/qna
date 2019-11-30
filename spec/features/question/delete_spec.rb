# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his own question', "
As an authenticated user
I'd like to be able to delete my own question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_not_owned) { create(:question) }

  describe 'Authenticated user' do

    background { sign_in(user) }

    scenario 'deletes his own question' do
      visit question_path(question)
      click_on 'Delete', id: 'delete_question'

      expect(page).to have_content 'Your question was deleted'
      expect(page).to_not have_content question.title
    end

    scenario 'tries to delete not his own question' do
      visit question_path(question_not_owned)

      expect(page).to_not have_link('Delete', id: 'delete_question')
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link('Delete', id: 'delete_question')
  end
end
