require 'rails_helper'

RSpec.feature 'UsersEdits', type: :feature do
  let(:admin) { FactoryBot.create(:user) }
  let(:user_params) { FactoryBot.attributes_for(:user) }

  it 'successful edit with friendly forwarding' do
    visit edit_user_path(admin)
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: admin.password
    click_button 'Log in'
    expect(page).to have_content 'Update your profile'
    fill_in 'Name', with: user_params[:name]
    fill_in 'Email', with: user_params[:email]
    click_button 'Save change'
    expect(current_path).to eq "/users/#{admin.id}"
    expect(page).to have_content user_params[:name]
    expect(page).to have_content 'Profile is successfully updated'
    click_link 'Log out'
    visit :login
    fill_in :session_email, with: user_params[:email]
    fill_in :session_password, with: admin.password
    click_button 'Log in'
    expect(current_path).to eq "/users/#{admin.id}"
  end

  describe 'with invalid signup information' do
    before do
      visit :login
      fill_in :session_email, with: admin.email
      fill_in :session_password, with: admin.password
      click_button 'Log in'
    end

    after do
      expect(page).to have_content 'Update your profile'
    end

    it 'without name' do
      visit edit_user_path(admin)
      fill_in 'Name', with: ''
      fill_in 'Email', with: user_params[:email]
      click_button 'Save change'
      expect(page).to have_content 'The form contains 1 error.'
      expect(page).to have_content 'Name can\'t be blank'
    end
    it 'without email' do
      visit edit_user_path(admin)
      fill_in 'Name', with: user_params[:name]
      fill_in 'Email', with: ''
      click_button 'Save change'
      expect(page).to have_content 'The form contains 2 errors.'
      expect(page).to have_content 'Email can\'t be blank'
    end
  end
end
