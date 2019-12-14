# frozen_string_literal: true

require 'rails_helper'

feature 'User can view his rewards', "
  As an author of the best question
  I'd like to be able to view my rewards
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:reward) { create(:reward, :with_image, question: question, user: user) }

  before do
    sign_in(user)
    visit rewards_path
  end

  scenario 'User views his rewards' do
    expect(page).to have_content question.title
    expect(page).to have_content reward.name
    expect(page).to have_selector('img')
  end
end
