require 'rails_helper'

feature 'User can unsubscribe to question', "
In order to stop receiving notifications
As an authenticated user
I'd like to be able to unsubscribe from question
" do
  let(:question) { create(:question) }
  scenario 'Unauthenticated user' do
    visit question_path(question)

    expect(page).to_not have_link('Unsubscribe')
  end

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    context 'not subscribed' do
      scenario 'tries to unsubscribe from question' do
        visit question_path(question)

        expect(page).to_not have_link('Unsubscribe')
      end
    end

    context 'subscribed' do
      background { question.subscribe(user) }

      scenario 'unsubscribes from question', js: true do
        visit question_path(question)

        click_on 'Unsubscribe'

        expect(page).to have_content 'You have been successfully unsubscribed'
      end
    end
  end
end