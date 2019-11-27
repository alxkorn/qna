require 'rails_helper'

feature 'User can sign out', "
In order to leave the site
As an authenticated user
I'd like to be able to sign out
" do
  given(:user) { create(:user) }
  background do
    sign_in(user) 
    visit root_path
  end 
  scenario 'Authenticated user signs out' do
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
