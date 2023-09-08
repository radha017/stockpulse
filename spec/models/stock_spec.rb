require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "validations" do
    it "is valid with a unique symbol" do
      stock = Stock.new(symbol: "AAPL")
      expect(stock).to be_valid
    end

    it "is not valid without a symbol" do
        stock = Stock.new(symbol: nil)
        puts stock.inspect
        expect(stock).to_not be_valid
      end      

    it "is not valid with a duplicate symbol" do
      Stock.create(symbol: "AAPL")
      stock = Stock.new(symbol: "AAPL")
      expect(stock).to_not be_valid
    end
  end
end