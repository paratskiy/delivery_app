require 'rails_helper'

RSpec.feature 'Signing Up', type: :feature do
  let(:user_params) { FactoryBot.attributes_for(:user) }
  let(:admin) { FactoryBot.build(:user) }

  before { visit :signup }

  it 'sing me up' do
    fill_in 'Name', with: admin.name
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    fill_in 'user[password_confirmation]', with: admin.password
    click_button 'Create my account'
    expect(page).to have_content admin.name
    expect(page).to have_content 'Welcome to Delivery App!'
    expect(current_path).to eq "/users/#{User.first.id}"
  end

  describe 'with invalid signup information' do
    after do
      expect(page).to have_content 'Sign up'
    end

    it 'without name' do
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: user_params[:password]
      fill_in 'user[password_confirmation]', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Name can\'t be blank'
    end
    it 'without email' do
      fill_in 'Name', with: user_params[:name]
      fill_in 'Password', with: user_params[:password]
      fill_in 'user[password_confirmation]', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 2 errors.'
      expect(page).to have_content 'Email can\'t be blank'
    end
    it 'without password' do
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'user[password_confirmation]', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Password can\'t be blank'
    end
    it 'short password' do
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: 'a' * 5
      fill_in 'user[password_confirmation]', with: 'a' * 5
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
    it 'without password confirmation' do
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: user_params[:password]
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Password confirmation doesn\'t match Password'
    end
    it 'without all off sign up information' do
      click_button 'Create my account'
      expect(page).to have_content 'The form contains 4 errors.'
    end
  end
end
