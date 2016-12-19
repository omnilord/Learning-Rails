class Stock < ActiveRecord::Base
  class <<self
    def fetch_stock(ticker)
      ticker.upcase!
      return find_by_ticker(ticker) if exists?(ticker: ticker)

      stock_data = StockQuote::Stock.quote(ticker)
      return nil unless stock_data.name
      new_stock(stock_data)
    end

    def new_stock(stock)
      create(ticker: stock.symbol, name: stock.name, last_price: price(stock))
    end

    def price(stock)
      stock.last_trade_price_only ||
        "#{stock.close} (Closing)" || "#{stock.open} (Opening)" ||
        "Unavailable"
    end
  end
end

class Stock < ActiveRecord::Base
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def update_via_fetch(stock)
    slp = Stock.price(stock)
    self.last_price = slp unless self.last_price == slp
    self.name = stock.name unless self.name == stock.name
    self.save unless self.changed.empty?
    self
  end
end
