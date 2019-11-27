# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of questions', "
In order to browse for the question I may be interested in
As a user
I'd like be able to view the list of questions
" do
  given!(:questions) { create_list(:question, 2) }
  scenario 'User tries to view the list of questions' do
    visit questions_path

    questions.each { |q| expect(page).to have_content(q.title) }
  end
end
