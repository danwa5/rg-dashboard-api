class UpdateWatchlist
  prepend SimpleCommand

  attr_reader :watchlist, :params

  def initialize(watchlist, params)
    @watchlist = watchlist
    @params = params
  end

  def call
    return if all_params_empty?

    if add_stocks.any? || remove_stocks.any?
      sorted_set = SortedSet.new(watchlist.stocks)
      sorted_set.merge(add_stocks) if add_stocks.any?

      if remove_stocks.any?
        remove_stocks.each do |stock|
          sorted_set.delete_if { |set| set.include?(stock) }
        end
      end

      watchlist.stocks = sorted_set.to_a
    end

    watchlist.name = watchlist_name if watchlist_name
    watchlist.save!
  rescue => e
    raise WatchlistError, e.message
  end

  private

  def all_params_empty?
    watchlist_name.nil? && add_stocks.empty? && remove_stocks.empty?
  end

  def watchlist_name
    params.fetch(:name, nil)
  end

  def add_stocks
    @add_stocks ||= begin
      stocks = params.fetch(:add_stocks, [])
      stocks.keep_if { |s| s.present? }
    end
  end

  def remove_stocks
    @remove_stocks ||= begin
      stocks = params.fetch(:remove_stocks, [])
      stocks.keep_if { |s| s.present? }
    end
  end
end

class WatchlistError < StandardError; end
