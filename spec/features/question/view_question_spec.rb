require 'rails_helper'

feature "User can view question and it's answers", "
In order to get information which may help to resolve a problem
As a user
I'd like to be able to view question and it's answers
" do
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  scenario "User views question and it's answers" do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end