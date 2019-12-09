require 'rails_helper'

feature 'Author of answer can delete attachment', "
In order to correct mistake
As an author of answer
I'd like to be able to delete attached file
" do
  
  describe 'Authenticated user' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, :with_attached_file, user: user) }
    let(:answer_not_owned) { create(:answer, :with_attached_file) }
    
    background do
      sign_in(user)
    end

    scenario 'author deletes attached file', js: true do
      visit question_path(answer.question)
      fname = answer.files.first.filename.to_s

      within("#answer-#{answer.id}") do
        page.find('.files').click_on 'Delete'

        # save_and_open_page
        expect(page).to_not have_link fname
      end
    end

    scenario 'non author tries to delete attached file', js: true do
      visit question_path(answer_not_owned.question)

      within("#answer-#{answer_not_owned.id}") do
        within('.files') do
          expect(page).to_not have_link 'Delete'
        end
      end
    end

  end

end