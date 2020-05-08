require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /home' do
    it 'returns http success' do
      get '/static_pages/home'
      expect(response).to have_http_status(:success)
      assert_select 'title', 'Home | Delivery App'
    end
  end
end
