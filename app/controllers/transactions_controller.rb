class TransactionsController < ApplicationController
  def index
    console
    @stock = Stock.find_by(symbol: params[:symbol])
    @chart = {
      symbol: @stock.symbol,
      data: @stock.data.map { |result| [Time.at(result['t'] / 1000), result['o']] }
    } 
    @price = @stock.data.last['o']
    if user_signed_in?
    bought = current_user.transactions.where(stock_id: @stock.id, transaction_type: 'buy').sum(:quantity)
    sell = current_user.transactions.where(stock_id: @stock.id, transaction_type: 'sell').sum(:quantity)
    @owned_quantity = (bought - sell)
    end
 
  end
  
  

  def show
    symbol = params[:symbol]
    @stock = Stock.find_by(symbol: symbol)
    @price = @stock['data'].last['o']
    @quantity = params[:quantity].to_i
    @total_amount = @price * @quantity
    balance = current_user.balance
  end

  def buy
    symbol = params[:symbol]
    quantity = params[:quantity].to_i
    balance = current_user.balance
    user = current_user
    stock = Stock.find_by(symbol: symbol)
  
    price = stock.data.last['o']
    total_amount = price * quantity
    if balance >= total_amount
        @transaction = Transaction.new(
          user: user,
          stock: stock,
          transaction_type: 'buy',
          quantity: quantity,
          price: total_amount,
          timestamp: Time.now 
        )
      
        if @transaction.save
          user.subtract_balance(total_amount)
         
          flash[:success] = "You have successfully purchased #{quantity} shares of #{symbol}."
          redirect_to home_path 
        else
      
          flash[:error] = "An error occurred while processing your purchase."
          redirect_to display_path(symbol)
        end
      end
  end
  
  def sell
    symbol = params[:symbol]
    quantity = params[:quantity].to_i
    user = current_user
    stock = Stock.find_by(symbol: symbol)
    price = stock.data.last['o']
    total_amount = price * quantity
    
    bought = current_user.transactions.where(stock_id: stock.id, transaction_type: 'buy').sum(:quantity)
    sell = current_user.transactions.where(stock_id: stock.id, transaction_type: 'sell').sum(:quantity)
    owned_quantity = bought - sell
  
    if owned_quantity >= quantity
    
      @transaction = Transaction.new(
        user: user,
        stock: stock,
        transaction_type: 'sell', 
        quantity: quantity,
        price: total_amount,
        timestamp: Time.now 
      )
  
      if @transaction.save
        user.add_balance(total_amount)
       
        flash[:success] = "You have successfully sold #{quantity} shares of #{symbol}."
        redirect_to home_path 
      else
       
        flash[:error] = "An error occurred while processing your sale."
        redirect_to home_path(symbol)
      end
    else
    
      flash[:error] = "Insufficient quantity to sell."
      redirect_to home_path(symbol)
    end
  end
  
  def display
    symbol = params[:symbol]
    @stock = Stock.find_by(symbol: symbol)
    @price = @stock['data'].last['o']
    @quantity = params[:quantity].to_i
    @total_amount = @price * @quantity

    render :display, locals: { quantity: @quantity }
  end

  def displays
    symbol = params[:symbol]
    @stock = Stock.find_by(symbol: symbol)
    @price = @stock['data'].last['o']
    @quantity = params[:quantity].to_i
    @total_amount = @price * @quantity

    bought = current_user.transactions.where(stock_id: @stock.id, transaction_type: 'buy').sum(:quantity)
    sell = current_user.transactions.where(stock_id: @stock.id, transaction_type: 'sell').sum(:quantity)
    owned_quantity = bought - sell
    if owned_quantity < @quantity
      flash[:error] = "Insufficient quantity to sell."
      redirect_to home_path(symbol)
    else
    render :displays, locals: { quantity: @quantity }
    end
  end

end
