require 'rails_helper'

feature 'User can edit his question', "
In order to correct mistakes
As an authenticated user
I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_not_owned) { create(:question) }

  describe 'Authenticated user' do
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      within '.question_box' do
        click_on 'Edit'
        fill_in 'Title', with: 'title edited'
        fill_in 'Body', with: 'body edited'
        click_on 'Save'

        expect(page).to_not have_content(question.body)
        expect(page).to_not have_content(question.title)
        expect(page).to have_content('title edited')
        expect(page).to have_content('body edited')
        expect(page).to_not have_selector('textarea')
        expect(page).to_not have_selector('input')
      end
    end

    scenario 'edits his question attaching file', js: true do
      within '.question_box' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his question with errors', js: true do
      within '.question_box' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario "tries to edit other's question", js: true do
      visit question_path(question_not_owned)

      within '.question_box' do
        expect(page).to_not have_link('Edit')
      end
    end

  end

  scenario 'Unauthenticated user can not edit question', js: true do
    visit question_path(question)
    within '.question_box' do
      expect(page).to_not have_link 'Edit'
    end
  end
end