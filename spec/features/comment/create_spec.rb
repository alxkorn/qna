require 'rails_helper'

feature 'Authenticated User can leave comments under answers/question', "
In order to express my opinion on answer/question
As an authenticated user
I'd like to be able to leave comments
" do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated user', js: true do
    visit question_path(question)

    expect(page).to_not have_button 'Submit comment'
  end

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'leaves comment under question', js: true do
      within '.question_box' do
        fill_in 'Comment', with: 'question comment text'
        click_on 'Submit comment'

        expect(page).to have_content 'question comment text'
      end
    end

    scenario 'leaves comment under answer', js: true do
      within '.answers_list' do
        fill_in 'Comment', with: 'answer comment text'
        click_on 'Submit comment'

        expect(page).to have_content 'answer comment text'
      end
    end

    scenario 'leaves comment with error', js: true do
      within '.question_box' do
        fill_in 'Comment', with: ''
        click_on 'Submit comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question_box' do
          fill_in 'Comment', with: 'question comment text'
          click_on 'Submit comment'
  
          expect(page).to have_content 'question comment text'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'question comment text'
      end
    end
  end 

end