require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /new' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it 'invalid signup information' do
      user_params = FactoryBot.attributes_for(:user)
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
      post users_path, params: { user: FactoryBot.attributes_for(:user) }
      expect(User.count).to eq(1)
      expect(response).to redirect_to(assigns(:user))
      expect(flash[:success]).to match('Welcome to Delivery App!')
    end
  end

  describe 'login' do
    it 'login with valid information followed by logout' do
      get login_path
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
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
      follow_redirect!
      assert_select 'a[href=?]', login_path
      assert_select 'a[href=?]', logout_path, count: 0
      assert_select 'a[href=?]', user_path(user), count: 0
    end
  end
end
