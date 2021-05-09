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
    $WATCHLISTS.keys.include?(@watchlist_uid)
  end

  def fetch_watchlist
    watchlist = $WATCHLISTS[@watchlist_uid]

    {
      uid: @watchlist_uid,
      name: watchlist['name'],
      stocks: watchlist['tickers'].map{ |t| FetchStock.new(t).call }
    }
  end
end

class InvalidWatchlistError < StandardError; end
