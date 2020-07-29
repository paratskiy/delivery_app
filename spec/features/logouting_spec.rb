require 'rails_helper'

RSpec.feature 'Logining Up', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  it 'login me up' do
    visit login_path
    fill_in :session_email, with: user.email
    fill_in :session_password, with: user.password
    click_button 'Log in'
    click_on 'Log out'
    expect(current_path).to eq '/'
    expect(page).to have_content 'Welcome to the Delivery App'
    expect(page).to have_selector(:link, 'Sign up now!')
  end
end
