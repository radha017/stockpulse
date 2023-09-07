class CallApi
    def call 
      symbols = ["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA", "META","JPM","V", "NVDA","PG", "MA","CRM","PFE","WMT"]
      stocks = []
  
      symbols.each do |symbol|
        next if Stock.exists?(symbol: symbol)  
        
        url = "https://api.polygon.io/v2/aggs/ticker/#{symbol}/range/1/day/2023-01-08/2023-02-09?adjusted=true&sort=asc&limit=120&apiKey=jq8DC9llfikaIikyoV3Qe6_bW8PIOtjy"
        res = Faraday.get(url)
        data = JSON.parse(res.body)
        next if data['results'].nil?
  
        stock_result = Stock.new(symbol: symbol, data: data['results'])
        stock_result.save        
  
        stocks << data
      end 
      
      stocks
    end
  end
  