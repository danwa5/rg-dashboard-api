class WatchlistSerializer
  include JSONAPI::Serializer
  set_id :uid
  attributes :name

  attribute :stocks do |watchlist|
    watchlist.stocks.map do |ticker|
      FetchStock.new(ticker).call
    end
  end
end
