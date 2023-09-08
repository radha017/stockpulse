# spec/controllers/transactions_controller_spec.rb

require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
    let(:user) { User.create(email: 'test@example.com', password: 'password123') }
    let(:stock) do
      Stock.create(
        symbol: 'AAPL',
        data: [{ 't' => Time.now.to_i * 1000, 'o' => 150.0 }]  # Example stock data
      )
    end
  
  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns the requested stock and chart data' do
      get :index, params: { symbol: stock.symbol }
      expect(assigns(:stock)).to eq(stock)
      expect(assigns(:chart)).to be_present
      expect(assigns(:price)).to be_present
      expect(assigns(:owned_quantity)).to be_present
    end
    
    # Add more test cases for this action as needed
  end

  

  

  describe 'POST #buy' do
    it 'creates a buy transaction if balance is sufficient' do
      initial_balance = user.balance
      post :buy, params: { symbol: stock.symbol, quantity: 5 }
      user.reload
      expect(user.balance).to eq(initial_balance - 5 * stock.data.last['o'])
      expect(user.transactions.last.transaction_type).to eq('buy')
      
      # Add more assertions as needed
    end

    it 'does not create a buy transaction if balance is insufficient' do
      user.update(balance: 0)  # Set the user's balance to zero
      post :buy, params: { symbol: stock.symbol, quantity: 5 }
      user.reload
      expect(user.transactions.last).to be_nil
      
      # Add more assertions as needed
    end
    
    # Add more test cases for this action as needed
  end

  describe 'POST #sell' do
    context 'when selling valid quantity' do
        it 'creates a sell transaction and updates user balance' do
            # Create a buy transaction for the user
            buy_transaction = Transaction.create!(
              user: user,
              stock: stock,
              transaction_type: 'buy',
              quantity: 10,
              price: 1500.0,
              timestamp: Time.now
            )
          
            # Simulate the sell request
            post :sell, params: { symbol: 'AAPL', quantity: 5 }
          
            expect(response).to redirect_to(home_path)
            expect(flash[:success]).to eq("You have successfully sold 5 shares of AAPL.")
          
            # Check if a sell transaction was created
            sell_transaction = Transaction.last
            expect(sell_transaction).to be_present
            expect(sell_transaction.transaction_type).to eq('sell')
            expect(sell_transaction.quantity).to eq(5)
            expect(sell_transaction.user).to eq(user)
            expect(sell_transaction.stock).to eq(stock)
         
          
        end
    # Add more test cases for different scenarios
  end
 

  describe 'GET #display' do
    it 'assigns the requested stock and calculates total amount' do
      get :display, params: { symbol: stock.symbol, quantity: 10 }
      expect(assigns(:stock)).to eq(stock)
      expect(assigns(:price)).to be_present
      expect(assigns(:quantity)).to eq(10)
      expect(assigns(:total_amount)).to be_present
    end
    
  end

  describe 'POST #displays' do
  context 'when selling valid quantity' do
    it 'assigns the requested stock and quantity' do
      buy_transaction = Transaction.create!(
        user: user,
        stock: stock,
        transaction_type: 'buy',
        quantity: 10,
        price: 1500.0,
        timestamp: Time.now
      )

      post :displays, params: { symbol: 'AAPL', quantity: 5 }

      expect(response).to be_successful
      expect(assigns(:stock)).to eq(stock)
      expect(assigns(:quantity)).to eq(5)
      expect(assigns(:total_amount)).to eq(5 * stock.data.last['o'])
    end
  end

  context 'when selling an invalid quantity' do
    it 'redirects with an error message' do
      buy_transaction = Transaction.create!(
        user: user,
        stock: stock,
        transaction_type: 'buy',
        quantity: 5,
        price: 150.0,
        timestamp: Time.now
      )

      post :displays, params: { symbol: 'AAPL', quantity: 10 }

      expect(response).to redirect_to(home_path('AAPL'))
      expect(flash[:error]).to eq("Insufficient quantity to sell.")
    end
  end
end
end

end
