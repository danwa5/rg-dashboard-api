class FetchWatchlist
  def initialize(watchlist_uid)
    @watchlist_uid = watchlist_uid.to_s
  end

  def call
    raise InvalidWatchlistError, 'Watchlist not found' unless valid_watchlist?

    fetch_watchlist
  end

  private

  def valid_watchlist?
    watchlists.keys.include?(@watchlist_uid)
  end

  def watchlists
    {
      'a1b2c3' => {
        'name' => 'Buy the Dip!!!',
        'tickers' => %w(AMZN ETSY TSLA ROKU RDFN UBER SBUX)
      },
      'd4e5f6' => {
        'name' => 'Undervalued Stocks',
        'tickers' => %w(SNAP PINS SQ PTON TDOC DDOG)
      }
    }.freeze
  end

  def fetch_watchlist
    watchlist = watchlists[@watchlist_uid]

    {
      uid: @watchlist_uid,
      name: watchlist['name'],
      stocks: watchlist['tickers'].map{ |t| FetchStock.new(t).call }
    }
  end
end

class InvalidWatchlistError < StandardError; end
