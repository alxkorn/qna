# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete link', "
  In order to correct mistake
  As an author of linkable
  I'd like to be able to delete link
" do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user' do

    scenario '-author deletes link', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question_box' do
        within page.all(:css, '.links')[0] do
          click_on 'Delete'
        end

        expect(page).to_not have_link link.name
      end
    end

    scenario '-non author tries to delete link', js: true do
      sign_in(user_not_author)
      visit question_path(question)

      within '.question_box' do
        within page.all(:css, '.links')[0] do
          expect(page).to_not have_link 'Delete'
        end
      end
    end

  end
end
