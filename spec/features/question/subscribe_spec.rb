require 'rails_helper'

feature 'User can subscribe to question', "
In order to receive notifications
As an authenticated user
I'd like to be able to subscribe to question
" do
  let(:question) { create(:question) }
  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe')
  end

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    context 'Already subscribed' do
      before { question.subscribe(user) }

      scenario 'tries to subscribe second time' do
        visit question_path(question)

        expect(page).to_not have_link('Subscribe')
      end
    end

    scenario 'subscribes to question', js: true do
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to have_content 'You have been successfully subscribed'
    end
  end
end