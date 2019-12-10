# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an autjor of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:answer_not_owned) { create(:answer) }
  given(:google) { 'https://www.google.com' }

  scenario 'Unanuthenticated user can not edit answer' do
    visit question_path(question)

    expect(page.find('div', class: 'answers_list')).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within '.answers_list' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer attaching file', js: true do
      within '.answers_list' do
        click_on 'Edit'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer adding link', js: true do
      within '.answers_list' do
        click_on 'Edit'
        click_on 'Add link'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: google
        click_on 'Save'

        expect(page).to have_link 'My link', href: google
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers_list' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer", js: true do
      visit question_path(answer_not_owned.question)

      within '.answers_list' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
