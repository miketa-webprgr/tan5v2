require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#password=" do
    example "文字列を与えると、hashed_passwordは60文字になる" do
      user = User.new
      user.password = "password"
      expect(user.hashed_password).to be_kind_of(String)
      expect(user.hashed_password.size).to eq(60)
    end
    example "nilを与えると、hashed_passwordはnilになる" do
      user = User.new
      user.password = nil
      expect(user.hashed_password).to be_nil
    end
  end
  
  describe "値の正規化" do
    example "email 前後の空白を除去" do
      user = create(:user, email: " a@a.com ")
      expect(user.email).to eq("a@a.com")
    end
    example "email 前後の全角空白を除去" do
      user = create(:user, email: "　a@a.com\u{3000}")
      expect(user.email).to eq("a@a.com")
    end
    example "email の全角文字を半角に" do
      user = create(:user, email: "ａ＠ａ．ｃｏｍ")
      expect(user.email).to eq("a@a.com")
    end
  end
  describe "バリデーション" do
    example "email 重複したemailは無効" do
      user = create(:user, email: " a@a.com ")
      user = build(:user, email: " a@a.com ")
      expect(user).not_to be_valid
    end
    example "email の形式が不適切だと無効" do
      user = build(:user, email: " a@@a.com ")
      expect(user).not_to be_valid
      user = build(:user, email: "aa.com ")
      expect(user).not_to be_valid
      user = build(:user, email: "a@a.com")
      expect(user).to be_valid
      user = build(:user, email: " a@@a.com. ")
      expect(user).not_to be_valid
    end
  end
end
