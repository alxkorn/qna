require 'rails_helper'

feature 'User can view list of questions', "
In order to navigate to required question
As a user
I'd like be able to view the list of questions
" do

  given!(:question) { create(:question) }
  scenario 'User tries to view the list of questions' do
    visit questions_path
    click_on question.title
    
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

end