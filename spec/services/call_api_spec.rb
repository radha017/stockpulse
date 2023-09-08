# spec/services/call_api_spec.rb

require 'rails_helper'
require 'webmock/rspec'  # For stubbing HTTP requests

RSpec.describe CallApi do
  describe '#call' do
    before do
      # Stub the HTTP request made by Faraday to avoid actual API calls
      stub_request(:get, /api.polygon.io/).to_return(
        status: 200,
        body: '{"results": []}',  # Sample JSON response
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
      }.to change(Stock, :count).by(14)  # 14 symbols in the array
    end

    it 'skips existing Stock records' do
      # Create existing Stock records with symbols
      existing_symbols = ["AAPL", "MSFT"]
      existing_symbols.each { |symbol| Stock.create(symbol: symbol) }

      expect {
        call_api = CallApi.new
        call_api.call
      }.to change(Stock, :count).by(12)  # Only 12 new symbols should be added
    end
  end
end
