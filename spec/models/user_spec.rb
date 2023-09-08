require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(
        email: "user@example.com",
        password: "password123",
        balance: 100.0
      )
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = User.new(email: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
      user = User.new(password: nil)
      expect(user).to_not be_valid
    end

    it "is not valid with a negative balance" do
      user = User.new(balance: -10.0)
      expect(user).to_not be_valid
    end
  end

  describe "instance methods" do
    let(:user) { User.new(balance: 100.0) }

    it "can add balance" do
      user.add_balance(50.0)
      expect(user.balance).to eq(150.0)
    end

    it "can subtract balance" do
      user.subtract_balance(25.0)
      expect(user.balance).to eq(75.0)
    end
  end
end