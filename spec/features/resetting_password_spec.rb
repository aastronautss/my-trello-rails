require 'rails_helper'

feature 'resetting password' do
  given(:user) { Fabricate :user }

  scenario 'with valid email' do
    visit new_password_reset_path
    fill_in 'Email', with: user.email
    click_button 'Submit'

    open_email user.email
    current_email.click_link 'Reset password'

    fill_in 'Password', with: 'newpassword'
    fill_in 'Confirm Password', with: 'newpassword'
    click_button 'Reset'

    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'newpassword'
    click_button 'Login'

    expect(page).to have_content 'Logout'
  end
end
