class CreateWatchlist
  prepend SimpleCommand

  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    raise WatchlistError, 'A watchlist with the same name already exists' if Watchlist.where(user: user, name: params[:name]).exists?

    Watchlist.create!(
      user: user,
      name: params[:name],
      stocks: params[:stocks]
    )
  end
end

class WatchlistError < StandardError; end
