require 'rails_helper'

RSpec.describe "TangoData", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/tango_data/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/tango_data/update"
      expect(response).to have_http_status(:success)
    end
  end

end
