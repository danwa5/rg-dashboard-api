class UpdateWatchlist
  prepend SimpleCommand

  attr_reader :watchlist, :params

  def initialize(watchlist, params)
    @watchlist = watchlist
    @params = params
  end

  def call
    if new_stocks.any?
      sorted_set = SortedSet.new(watchlist.stocks)
      sorted_set.merge(new_stocks)
      watchlist.stocks = sorted_set.to_a
    end

    watchlist.name = watchlist_name if watchlist_name
    watchlist.save!
  rescue => e
    raise WatchlistError, e.message
  end

  private

  def watchlist_name
    params.fetch(:name, nil)
  end

  def new_stocks
    stocks = params.fetch(:new_stocks, [])
    stocks.keep_if { |s| s.present? }
  end
end

class WatchlistError < StandardError; end
