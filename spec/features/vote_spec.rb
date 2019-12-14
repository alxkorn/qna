# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question and answer', "
  In order to encourage user for good question/answer
  As an authenticated user
  I'd like to be able to vote for question/answer
" do
  given(:user) { create(:user) }
  given(:user_not_author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Any user' do
    background { visit question_path(question) }

    scenario 'can view rating of resource' do
      within '.question_box' do
        rating = page.find('.rating')
        expect(rating).to have_content question.rating
      end

      within '.answers_list' do
        rating = page.find('.rating')
        expect(rating).to have_content answer.rating
      end
    end
  end

  describe 'Authenticated user - author of resource' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'cannot vote for his resource' do
      expect(page).to_not have_link 'Upvote'
      expect(page).to_not have_link 'Downvote'
      expect(page).to_not have_link 'Cancel vote'
    end
  end

  describe 'Authenticated user - not author of resource', js: true do
    background do
      sign_in(user_not_author)
      visit question_path(question)
    end

    scenario 'can upvote resource' do
      within '.question_box' do
        click_on 'Upvote'
        rating = page.find('.rating')

        expect(rating).to have_content question.rating + 1
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Upvote'
      end

      within '.answers_list' do
        click_on 'Upvote'
        rating = page.find('.rating')

        expect(rating).to have_content answer.rating + 1
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Upvote'
      end
    end

    scenario 'can downvote resource' do
      within '.question_box' do
        click_on 'Downvote'
        rating = page.find('.rating')

        expect(rating).to have_content question.rating - 1
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Upvote'
      end

      within '.answers_list' do
        click_on 'Downvote'
        rating = page.find('.rating')

        expect(rating).to have_content answer.rating - 1
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Upvote'
      end
    end

    scenario 'can cancel his vote' do
      within '.question_box' do
        click_on 'Downvote'
        click_on 'Cancel vote'
        rating = page.find('.rating')

        expect(rating).to have_content question.rating
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_link 'Downvote'
        expect(page).to have_link 'Upvote'
      end

      within '.answers_list' do
        click_on 'Downvote'
        click_on 'Cancel vote'
        rating = page.find('.rating')

        expect(rating).to have_content answer.rating
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_link 'Downvote'
        expect(page).to have_link 'Upvote'
      end
    end
  end
end
