require 'rails_helper'
require 'webmock/rspec' 

RSpec.describe CallApi do
  describe '#call' do
    before do
      stub_request(:get, /api.polygon.io/).to_return(
        status: 200,
        body: '{"results": []}',  
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    it 'returns an array of stock data' do
      call_api = CallApi.new
      stocks = call_api.call
      expect(stocks).to be_an(Array)
    end

    it 'creates new Stock records' do
      expect {
        call_api = CallApi.new
        call_api.call
      }.to change(Stock, :count).by(14) 
    end

    it 'skips existing Stock records' do
      existing_symbols = ["AAPL", "MSFT"]
      existing_symbols.each { |symbol| Stock.create(symbol: symbol) }

      expect {
        call_api = CallApi.new
        call_api.call
      }.to change(Stock, :count).by(12) 
    end
  end
end
