require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do

  describe "GET #return" do
    it "returns http success" do
      get :return
      expect(response).to have_http_status(:success)
    end
  end

end
