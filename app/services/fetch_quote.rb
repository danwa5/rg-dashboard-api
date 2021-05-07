class FetchQuote
  def initialize(ticker)
    @ticker = String(ticker).upcase
  end

  def call
    raise InvalidTickerError, "'#{@ticker}' is an invalid ticker" unless companies.keys.include?(@ticker)

    open_price = Faker::Commerce.price
    change = Faker::Number.between(from: 0.0, to: 0.3).round(3) * [-1, -1, 0, 1, 1, 1, 1].sample

    {
      ticker: @ticker,
      ticker_color: ticker_color,
      company_name: company_name,
      open_price: open_price,
      delta: change,
      current_price: (open_price * factor(change)).round(2)
    }
  end

  private

  def factor(change)
    change.zero? ? 1 : (1 + change)
  end

  def ticker_color
    companies[@ticker]['ticker_color']
  end

  def company_name
    companies[@ticker]['company_name']
  end

  def companies
    {
      'AAPL' => {
        'company_name' => 'Apple Inc',
        'ticker_color' => '#666666'
      },
      'AMC' => {
        'company_name' => 'AMC Entertainment',
        'ticker_color' => '#E32226'
      },
      'AMZN' => {
        'company_name' => 'Amazon.com, Inc.',
        'ticker_color' => '#C26C03'
      },
      'FB' => {
        'company_name' => 'Facebook, Inc. Common Stock',
        'ticker_color' => '#4267B2'
      },
      'MSFT' => {
        'company_name' => 'Microsoft Corporation',
        'ticker_color' => '#737373'
      },
      'NVDA' => {
        'company_name' => 'NVIDIA Corporation',
        'ticker_color' => '#5B9000'
      },
      'TSLA' => {
        'company_name' => 'Tesla Inc',
        'ticker_color' => '#E31937'
      }
    }.freeze
  end
end

class InvalidTickerError < StandardError; end
