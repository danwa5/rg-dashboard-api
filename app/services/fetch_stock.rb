class FetchStock
  def initialize(ticker)
    @ticker = String(ticker).upcase
  end

  def call
    raise InvalidTickerError, "'#{@ticker}' is an invalid ticker" unless valid_ticker?

    open_price = Faker::Commerce.price
    change = Faker::Number.between(from: 0.0, to: 0.3).round(3) * [-1, -1, 0, 1, 1, 1, 1].sample

    {
      ticker: @ticker,
      ticker_color: ticker_color,
      company_name: company_name,
      open_price: open_price,
      delta: change,
      current_price: (open_price * factor(change)).round(2),
      tags: tags
    }
  end

  private

  def valid_ticker?
    $COMPANIES.keys.include?(@ticker)
  end

  def factor(change)
    change.zero? ? 1 : (1 + change)
  end

  def ticker_color
    $COMPANIES[@ticker]['ticker_color'] || '#000'
  end

  def company_name
    $COMPANIES[@ticker]['company_name']
  end

  def tags
    $COMPANIES[@ticker]['tags'] || []
  end
end

class InvalidTickerError < StandardError; end
