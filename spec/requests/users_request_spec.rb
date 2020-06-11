require 'rails_helper'


describe "Userについて", "ログイン前" do
  include_examples "a protected admin controller", "users"
end

RSpec.describe "Userについて", type: :request do
  let(:user_params) { attributes_for(:user)}
  let(:user) { create(:user)}
  describe "新規登録" do
    example "rootにリダイレクト" do
      post users_url,params: { user: user_params}
      expect(response).to redirect_to(root_url)
    end
    example "各パラメータが登録されている" do
      post users_url,params: { user: user_params}
      user.reload
      expect(user.name).to eq("jiro")
    end
    example "rootにリダイレクト" do
      post users_url,params: { user: user_params}
      expect(response).to redirect_to(root_url)
    end
  end
end
