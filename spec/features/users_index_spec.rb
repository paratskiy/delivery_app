require 'rails_helper'

RSpec.feature 'UsersIndices', type: :feature do
  let(:admin) { FactoryBot.create(:user) }
  let(:first_page_user) { User.paginate(page: 1)[1] }
  let(:second_page_user) { User.paginate(page: 2)[0] }

  before do
    admin
    60.times do
      FactoryBot.create(:user)
    end
  end

  it 'index testing pagination' do
    visit :login
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: admin.password
    click_button 'Log in'
    visit users_path
    expect(page).to have_selector(:css, 'div.pagination')
    expect(page).to have_link(first_page_user.name,
                              href: user_path(first_page_user))
    first("a[href='/users?page=2']").click
    expect(page).to have_link(second_page_user.name,
                              href: user_path(second_page_user))
  end

  it 'delete user' do
    visit :login
    fill_in :session_email, with: admin.email
    fill_in :session_password, with: admin.password
    click_button 'Log in'
    visit users_path
    expect(page).to have_link('delete', href: user_path(first_page_user))
    first("a[href='#{user_path(first_page_user)}'][data-method='delete']").click
    expect(page).not_to have_link(first_page_user.name,
                                  href: user_path(first_page_user))
  end
end
