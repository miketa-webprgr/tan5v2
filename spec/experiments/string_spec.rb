require "spec_helper"

describe String do
  describe "#<<" do
    example "文字の追加" do
      s = "AB"
      s << "C"
      expect(s.size).to eq(3)
    end
  end
end

