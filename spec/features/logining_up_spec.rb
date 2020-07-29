require 'rails_helper'

RSpec.feature 'Logining Up', type: :feature do
  let(:user) { FactoryBot.create(:user) }

  before { visit login_path }

  it 'login me up' do
    fill_in :session_email, with: user.email
    fill_in :session_password, with: user.password
    click_button 'Log in'
    expect(current_path).to eq "/users/#{user.id}"
    expect(page).to have_content user.name
    expect(page).to have_content 'Log out'
  end

  it 'with invalid login information' do
    fill_in :session_email, with: ''
    fill_in :session_password, with: ''
    click_button 'Log in'
    expect(current_path).to eq '/login'
    expect(page).to have_selector('.alert-danger')
    expect(page).to have_link(nil, href: '/signup')
    expect(page).to have_selector(:button, 'Log in')
    visit root_path
    expect(page).not_to have_selector('.alert-danger')
  end
end
