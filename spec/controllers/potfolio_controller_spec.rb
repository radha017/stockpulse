require 'rails_helper'
require 'webmock/rspec'

RSpec.describe PortfoliosController, type: :controller do
    before do
        sign_in user
    
        stub_request(:get, /api\.polygon\.io/).to_return(status: 200, body: sample_api_response.to_json)
      end
   
  let(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password',
    )
  end

  def sample_api_response

    {
      'AAPL' => {
        'symbol' => 'AAPL',
        'data' => [
          { 't' => 1641408000000, 'o' => 150.0 },
          { 't' => 1641494400000, 'o' => 155.0 },
    
        ]
      },
      'MSFT' => {
        'symbol' => 'MSFT',
        'data' => [
          { 't' => 1641408000000, 'o' => 300.0 },
          { 't' => 1641494400000, 'o' => 305.0 },
        
        ]
      },
    
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

    stock1 = Stock.create(symbol: 'AAPL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 150.0 }])
    stock2 = Stock.create(symbol: 'GOOGL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 2000.0 }])
    
    get :market

    expect(response).to be_successful
    expect(assigns(:charts)).not_to be_nil


    expect(assigns(:charts)).to include(
      { symbol: stock1.symbol, data: stock1.data.map { |result| [Time.at(result['t'] / 1000), result['o']] } },
      { symbol: stock2.symbol, data: stock2.data.map { |result| [Time.at(result['t'] / 1000), result['o']] } }
    )
  end
end

describe 'GET #portfolio' do
  it 'calculates owned quantities and total for each owned stock' do

    stock1 = Stock.create(symbol: 'AAPL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 150.0 }])
    stock2 = Stock.create(symbol: 'GOOGL', data: [{ 't' => Time.now.to_i * 1000, 'o' => 2000.0 }])

    Transaction.create(user: user, stock: stock1, transaction_type: 'buy', quantity: 5, price: 150.0)
    Transaction.create(user: user, stock: stock2, transaction_type: 'buy', quantity: 10, price: 2000.0)
    get :portfolio


    expect(assigns(:user)).to eq(user)
    expect(assigns(:owned_stocks)).to contain_exactly(stock1, stock2)

    total = {}

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
