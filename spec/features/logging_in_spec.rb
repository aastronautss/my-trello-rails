require 'rails_helper'

feature 'logging in' do
  given(:user) { Fabricate :user, password: 'asdfg', activated: true }

  scenario 'with correct credentials' do
    visit login_path
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'asdfg'
    click_button 'Login'

    expect(page).to have_content('You have successfully logged in.')
  end

  scenario 'with correct credentials and remember box checked' do
    visit login_path
    fill_in 'Username', with: user.username
    fill_in 'Password', with: 'asdfg'
    check 'Remember'
    click_button 'Login'

    expect(page).to have_content('You have successfully logged in.')

    expire_cookies

    visit root_path
    expect(page).to have_content('Logout')
  end
end
