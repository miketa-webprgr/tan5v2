require 'rails_helper'

RSpec.describe "Wordnotes", type: :request do

  describe "GET /create" do
    it "returns http success" do
      get "/wordnotes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/wordnotes/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/wordnotes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
