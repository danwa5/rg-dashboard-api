class WatchlistSerializer
  include JSONAPI::Serializer
  set_id :uid
  attributes :name

  attribute :stocks do |watchlist, params|
    if watchlist.stocks.present?
      if params[:new_watchlist?]
        watchlist.stocks
      else
        watchlist.stocks.map do |ticker|
          FetchStock.new(ticker).call
        end
      end
    else
      []
    end
  end
end
