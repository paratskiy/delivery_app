require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /home' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
      assert_select 'title', full_title('Home')
    end
    it 'layout links' do
      get root_path
      assert_template 'static_pages/home'
      # assert_select "a[href=?]", signup_pat
      # assert_select "a[href=?]", login_path
    end
  end
end
