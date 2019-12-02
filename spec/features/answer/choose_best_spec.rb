require 'rails_helper'

feature 'Author of question can choose best answer', "
In order to highlight best solution of my problem
As an author of question
I'd like to be able to choose best answer
" do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Authenticated user' do

    scenario '- author chooses best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within('div', class: 'answer_box', id: "answer-#{answers[1].id}") do
        click_on 'Set as best'

        expect(page).to have_content 'Best answer:'
      end
      expect(page.find_all('div', class: 'answer_box').first[:id]).to eq "answer-#{answers[1].id}"
    end

    scenario '- not author tries to choose best answer', js: true do
      sign_in(user_not_author)
      visit question_path(question)

      expect(page).to_not have_link 'Set as best'
    end
  end

  scenario 'Unauthenticated user tries to choose best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Set as best'
  end
end