require 'rails_helper'

RSpec.describe 'UsersIndex', type: :request do
  let(:admin) { FactoryBot.create(:user) }
  let(:non_admin) { User.last }

  before do
    expect(admin)
    30.times do
      FactoryBot.create(:user)
    end
  end

  it 'index including pagination' do
    log_in_as(admin)
    get users_path
    expect(response).to render_template('users/index')
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      next if user == admin

      assert_select 'a[href=?]', user_path(user), text: 'delete'
    end
    count_of_users = User.count
    expect do
      delete user_path(User.last)
    end.to change(User, :count).from(count_of_users).to(count_of_users - 1)
  end

  it 'index as non-admin' do
    log_in_as(non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
