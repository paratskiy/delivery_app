require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:user_params) { FactoryBot.attributes_for(:user) }

  describe 'GET /new' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it 'invalid signup information' do
      user_params[:name] = ''
      get signup_path
      expect(response).to render_template(:new)
      post users_path, params: { user: user_params }
      expect(response).to render_template(:new)
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
    end

    it 'creates a User and redirects to the User page' do
      get signup_path
      expect(response).to render_template(:new)
      post users_path, params: { user: user_params }
      expect(User.count).to eq(1)
      expect(response).to redirect_to(assigns(:user))
      expect(flash[:success]).to match('Welcome to Delivery App!')
      assert_select 'a[href=?]', login_path, count: 0
      expect(is_logged_in?).to be true
    end
  end

  describe 'login' do
    it 'login with valid information followed by logout' do
      log_in_as(user)
      expect(is_logged_in?).to be true
      expect(response).to redirect_to user
      follow_redirect!
      expect(response).to render_template('users/show')
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', user_path(user)
      delete logout_path
      expect(is_logged_in?).to be false
      expect(response).to redirect_to root_url
      delete logout_path
      follow_redirect!
      assert_select 'a[href=?]', login_path
      assert_select 'a[href=?]', logout_path, count: 0
      assert_select 'a[href=?]', user_path(user), count: 0
    end

    it 'login with remembering' do
      log_in_as(user, remember_me: '1')
      expect(cookies['remember_token']).to eq assigns(:user).remember_token
    end

    it 'login without remembering' do
      log_in_as(user, remember_me: '0')
      expect(cookies['remember_token']).to be_nil
    end
  end
end
