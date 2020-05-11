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

  describe 'with invalid signup information' do
    it 'without name' do
      visit signup_path
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: user_params[:password]
      fill_in 'user[password_confirmation]', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Name can\'t be blank'
    end
    it 'without email' do
      visit signup_path
      fill_in 'Name', with: user_params[:name]
      fill_in 'Password', with: user_params[:password]
      fill_in 'user[password_confirmation]', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 2 errors.'
      expect(page).to have_content 'Email can\'t be blank'
    end
    it 'without password' do
      visit signup_path
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'user[password_confirmation]', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 3 errors.'
      expect(page).to have_content 'Password can\'t be blank'
    end
    it 'short password' do
      visit signup_path
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: 'a' * 5
      fill_in 'user[password_confirmation]', with: 'a' * 5
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
    it 'without password confirmation' do
      visit signup_path
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Password confirmation doesn\'t match Password'
    end
    it 'without all off sign up information' do
      visit signup_path
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 6 errors.'
    end
  end
end
