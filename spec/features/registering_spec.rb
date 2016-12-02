require 'rails_helper'

feature 'registering' do
  scenario 'with valid information' do
    visit register_path
    fill_in 'Username', with: 'tyler'
    fill_in 'Email', with: 'tyler@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Register'

    open_email 'tyler@example.com'
    current_email.click_link 'Activate'

    expect(page).to have_content 'Logout'
  end
end
