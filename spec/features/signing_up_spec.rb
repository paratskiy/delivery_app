require 'rails_helper'

RSpec.feature 'Signing Up', type: :feature do
  let(:user_params) { FactoryBot.attributes_for(:user) }

  it 'sing me up' do
    visit signup_path
    fill_in 'Name', with: user_params[:name]
    fill_in 'Email', with: user_params[:email]
    fill_in 'Password', with: user_params[:password]
    fill_in 'user[password_confirmation]', with: user_params[:password]
    click_button 'Create my account'
    expect(page).to have_content user_params[:name]
    expect(page).to have_content 'Welcome to Delivery App!'
  end
end
