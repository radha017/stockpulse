class PortfoliosController < ApplicationController
  before_action :CallApi, only: [:home]
  def home
  end

  def market
    stocks = Stock.all
    @charts = []
    stocks.each do |data|
    chart = {
        symbol: data['symbol'],
        data: data['data'].map { |result| [Time.at(result['t'] / 1000), result['o']] }
      }
      @charts << chart
    end
  end

  def portfolio
    @user = current_user
    @owned_stocks = @user.transactions.where(transaction_type: 'buy').map(&:stock).uniq
    @owned_quantities = {} 
    
    @owned_stocks.each do |stock|
        price = stock.data.last['o']
        @owned_quantities[stock] = @user.transactions.where(stock: stock, transaction_type: 'buy').sum(:quantity)
      
    end
    
  end

  def history
    @transac = Transaction.all
    @transactions = Transaction.order(created_at: :desc).where(user_id: current_user.id)
  end

  

  private
  def CallApi
    CallApi.new.call
  end
end
