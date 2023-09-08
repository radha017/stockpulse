require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "validations" do
    it "requires a user" do
      transaction = Transaction.new(user: nil)
      expect(transaction).to_not be_valid
    end
    
    it "requires a stock" do
      transaction = Transaction.new(stock: nil)
      expect(transaction).to_not be_valid
    end

    it "requires a transaction_type" do
      transaction = Transaction.new(transaction_type: nil)
      expect(transaction).to_not be_valid
    end

    it "validates inclusion of transaction_type" do
      transaction = Transaction.new(transaction_type: "invalid_type")
      expect(transaction).to_not be_valid
    end

    it "validates numericality of quantity" do
      transaction = Transaction.new(quantity: "invalid_quantity")
      expect(transaction).to_not be_valid
    end

    it "validates numericality of price" do
      transaction = Transaction.new(price: "invalid_price")
      expect(transaction).to_not be_valid
    end
  end

  describe "associations" do
    it "belongs to a user" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a stock" do
      association = described_class.reflect_on_association(:stock)
      expect(association.macro).to eq(:belongs_to)
    end
  end      
end
