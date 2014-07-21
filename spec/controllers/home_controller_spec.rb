require 'spec_helper'

describe HomeController do
  describe 'GET #show' do
    it 'renders the :show template successfully' do
      get :show
      assert_response :success
      assert_template :show
    end
  end
end
