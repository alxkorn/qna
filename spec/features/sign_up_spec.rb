require 'rails_helper'

feature 'User can sign up', "
In order to bable to ask questions
As unregistered user
I'd like to be able to sign up
" do

  background { visit new_user_registration_path }

  scenario 'User signs up with valid attributes' do
    fill_in 'Email', with: 'user1@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'

    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with invalid attributes' do
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '1'

    click_button 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved'

  end
end