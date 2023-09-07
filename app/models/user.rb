class User < ApplicationRecord
  has_many :transactions
  has_many :stocks
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }  
  enum role: { trader: false, admin: true} 

  def add_balance(amount)
    self.balance += amount
    save
  end

  def subtract_balance(amount)
    self.balance -= amount
    save
  end
end
