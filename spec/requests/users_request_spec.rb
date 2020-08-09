require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:admin) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:user_params) { FactoryBot.attributes_for(:user) }

  it 'should redirect index when not logged in' do
    get users_path
    expect(response).to redirect_to(:login)
  end

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
      expect do
        post users_path, params: { user: user_params }
      end.to change(User, :count).by(1)
      expect(response).to redirect_to(assigns(:user))
      expect(flash[:success]).to match('Welcome to Delivery App!')
      assert_select 'a[href=?]', login_path, count: 0
      expect(is_logged_in?).to be true
    end
  end

  describe 'login' do
    it 'login with valid information followed by logout' do
      log_in_as(admin)
      expect(is_logged_in?).to be true
      expect(response).to redirect_to admin
      follow_redirect!
      expect(response).to render_template('users/show')
      assert_select 'a[href=?]', login_path, count: 0
      assert_select 'a[href=?]', logout_path
      assert_select 'a[href=?]', user_path(admin)
      delete logout_path
      expect(is_logged_in?).to be false
      expect(response).to redirect_to :root
      delete logout_path
      follow_redirect!
      assert_select 'a[href=?]', login_path
      assert_select 'a[href=?]', logout_path, count: 0
      assert_select 'a[href=?]', user_path(admin), count: 0
    end

    it 'login with remembering' do
      log_in_as(admin, remember_me: '1')
      expect(cookies['remember_token']).to eq assigns(:user).remember_token
    end

    it 'login without remembering' do
      log_in_as(admin, remember_me: '0')
      expect(cookies['remember_token']).to be_nil
    end

    it 'should redirect edit when not logged in' do
      get edit_user_path(admin)
      expect(flash).not_to be_empty
      expect(response).to redirect_to(:login)
    end

    it 'should redirect update when not logged in' do
      patch user_path(admin), params: { user: { name: admin.name,
                                                email: admin.email } }
      expect(flash).not_to be_empty
      expect(response).to redirect_to(:login)
    end

    it 'should redirect edit when logged in as wrong user' do
      log_in_as(other_user)
      get edit_user_path(admin)
      expect(flash).to be_empty
      expect(response).to redirect_to(:root)
    end

    it 'should redirect update when logged in as wrong user' do
      log_in_as(other_user)
      patch user_path(admin), params: { user: { name: admin.name,
                                                email: admin.email } }
      expect(flash).to be_empty
      expect(response).to redirect_to(:root)
    end
  end

  describe 'destroy' do
    it 'should redirect destroy when not logged in' do
      expect(other_user)
      expect { delete user_path(other_user) }.to_not change(User, :count)
      expect(response).to redirect_to(:login)
    end

    it 'should redirect destroy when logged in as a non-admin' do
      expect(admin)
      log_in_as(other_user)
      expect { delete user_path(other_user) }.to_not change(User, :count)
      expect(response).to redirect_to(:root)
    end
  end

  it 'should not allow the admin attribute to be edited via the web' do
    expect(admin)
    log_in_as(other_user)
    expect(other_user.admin?).to be false
    patch user_path(other_user), params: { user: { password: '',
                                                   password_confirmation: '',
                                                   admin: true } }
    expect(other_user.reload.admin?).to be false
  end
end
