require 'rails_helper'
require 'webmock/rspec'

RSpec.describe PortfoliosController, type: :controller do
    before do
        sign_in user
        # Stub the external API requests
        stub_request(:get, /api\.polygon\.io/).to_return(status: 200, body: sample_api_response.to_json)
      end
   
  let(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password',
      # other attributes you need for your test user
    )
  end

  def sample_api_response
    # Create a sample API response that matches the expected format of the external API
    {
      'AAPL' => {
        'symbol' => 'AAPL',
        'data' => [
          { 't' => 1641408000000, 'o' => 150.0 },
          { 't' => 1641494400000, 'o' => 155.0 },
          # Add more data points as needed
        ]
      },
      'MSFT' => {
        'symbol' => 'MSFT',
        'data' => [
          { 't' => 1641408000000, 'o' => 300.0 },
          { 't' => 1641494400000, 'o' => 305.0 },
          # Add more data points as needed
        ]
      },
      # Add data for other symbols
    }
  end

  describe 'GET #home' do
    it 'returns a successful response' do
      sign_in user
      get :home
      expect(response).to be_successful
    end
  end

  describe 'GET #market' do
  it 'populates @charts with stock data' do
    # Create some sample stocks with data
    stock1 = Stock.create(symbol: 'AAPL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 150.0 }])
    stock2 = Stock.create(symbol: 'GOOGL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 2000.0 }])
    
    # Call the market action
    get :market

    # Expectations
    expect(response).to be_successful
    expect(assigns(:charts)).not_to be_nil

    # Check if @charts contains the expected data for stock1 and stock2
    expect(assigns(:charts)).to include(
      { symbol: stock1.symbol, data: stock1.data.map { |result| [Time.at(result['t'] / 1000), result['o']] } },
      { symbol: stock2.symbol, data: stock2.data.map { |result| [Time.at(result['t'] / 1000), result['o']] } }
    )
  end
end




describe 'GET #portfolio' do
  it 'calculates owned quantities and total for each owned stock' do
    # Create some sample stocks and transactions for the user
    stock1 = Stock.create(symbol: 'AAPL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 150.0 }])
    stock2 = Stock.create(symbol: 'GOOGL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 2000.0 }])

    Transaction.create(user: user, stock: stock1, transaction_type: 'buy', quantity: 5, price: 150.0)
    Transaction.create(user: user, stock: stock2, transaction_type: 'buy', quantity: 10, price: 2000.0)

    # Call the portfolio action
    get :portfolio

    # Expectations
    expect(assigns(:user)).to eq(user)
    expect(assigns(:owned_stocks)).to contain_exactly(stock1, stock2)

    # Initialize total as an empty hash
    total = {}

    # Calculate @owned_quantities and @total for each stock
    assigns(:owned_stocks).each do |stock|
      total[stock] = assigns(:owned_quantities)[stock] * stock.data.last['o']
    end

  end
end

  describe 'GET #history' do
    it 'returns a successful response' do
      sign_in user
      get :history
      expect(response).to be_successful
    end
  end
end
