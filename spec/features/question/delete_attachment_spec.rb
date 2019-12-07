require 'rails_helper'

feature 'Author of question can delete attachment', "
In order to correct mistake
As an author of question
I'd like to be able to delete attached file
" do
  let(:question_not_owned) { create(:question, :with_attached_file) }

  describe 'Authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_attached_file, user: user) }
    
    background do
      sign_in(user)
    end

    scenario 'author deletes attached file', js: true do
      visit question_path(question)
      fname = question.files.first.filename.to_s

      within('.question_box') do
        page.find('.files').click_on 'Delete'
  
        expect(page).to_not have_link fname
      end
    end

    scenario 'non author tries to delete attached file', js: true do
      visit question_path(question_not_owned)

      within('.question_box') do
        within('.files') do
          expect(page).to_not have_link 'Delete'
        end
      end
    end

  end

end