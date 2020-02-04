require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #faq" do
    it "returns http success" do
      get :faq
      expect(response).to have_http_status(:success)
    end
  end

end
