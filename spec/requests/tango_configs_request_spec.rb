require 'rails_helper'

RSpec.describe "TangoConfigs", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/tango_configs/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/tango_configs/update"
      expect(response).to have_http_status(:success)
    end
  end

end
