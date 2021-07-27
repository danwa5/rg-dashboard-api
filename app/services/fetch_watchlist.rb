class FetchWatchlist
  prepend SimpleCommand
  attr_reader :current_user, :watchlist_uid

  def initialize(current_user, watchlist_uid)
    @current_user = current_user
    @watchlist_uid = watchlist_uid.to_s
  end

  def call
    watchlist = current_user.watchlists.find_by(uid: watchlist_uid)
    raise WatchlistNotFoundError, 'Watchlist not found' unless watchlist

    watchlist
  end
end

class WatchlistNotFoundError < StandardError; end
