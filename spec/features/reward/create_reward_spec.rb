# frozen_string_literal: true

require 'rails_helper'

feature 'User can add reward for question', "
  In order to encourage user for giving best answer
  As an author of the question
  I'd like to be able to create reward
" do
  given(:user) { create(:user) }

  before do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Autthenticated user creates reward' do
    expect(page).to have_content 'Reward'
    expect(page).to have_selector('label', text: 'Name')
    expect(page).to have_selector('label', text: 'Image')
  end
end
