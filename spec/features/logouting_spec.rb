require 'rails_helper'

RSpec.feature 'Logining Up', type: :feature do
  let(:admin) { FactoryBot.create(:user) }

  it 'login me up' do
    visit :login
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: admin.password
    click_button 'Log in'
    click_on 'Log out'
    expect(current_path).to eq '/'
    expect(page).to have_content 'Welcome to the Delivery App'
    expect(page).to have_selector(:link, 'Sign up now!')
  end
end
