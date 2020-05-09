require 'rails_helper'

RSpec.describe 'Users', type: :request do
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
      assert_template 'users/new'
    end

    it 'creates a User and redirects to the User page' do
      get signup_path
      expect(response).to render_template(:new)
      post users_path, params: { user: FactoryBot.attributes_for(:user) }
      expect(User.count).to eq(1)
      expect(response).to redirect_to(assigns(:user))
    end
  end
end
