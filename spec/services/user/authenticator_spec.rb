require "rails_helper"

describe Authenticator do
  describe "#authenticate" do
    example "正しいパスワードならtrueを返す" do
      user = build(:user)
      expect(Authenticator.new(user).authenticate("password")).to be_truthy
    end
   
    example "間違ったパスワードならfalseを返す" do
      user = build(:user)
      expect(Authenticator.new(user).authenticate("xyz")).to be_falsey
    end

    example "パスワードがないならfalseを返す" do
      user = build(:user, password: nil)
      expect(Authenticator.new(user).authenticate(nil)).to be_falsey
    end
    example "停止フラグがあればfalseを返す" do
      user = build(:user, suspended: true)
      expect(Authenticator.new(user).authenticate("password")).to be_falsey
    end
  end
end 
