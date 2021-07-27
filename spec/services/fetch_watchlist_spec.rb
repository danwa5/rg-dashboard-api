require 'rails_helper'

RSpec.describe FetchWatchlist do
  let(:user) { create(:user) }

  describe '#call' do
    context 'when watchlist is not found' do
      example do
        expect {
          described_class.call(user, Faker::Alphanumeric.alphanumeric)
        }.to raise_exception(WatchlistNotFoundError, 'Watchlist not found')
      end
    end

    context 'when watchlist belongs to another user' do
      example do
        watchlist = create(:watchlist)

        expect {
          described_class.call(user, watchlist.uid)
        }.to raise_exception(WatchlistNotFoundError, 'Watchlist not found')
      end
    end

    context 'when watchlist is found' do
      example do
        watchlist = create(:watchlist, user: user)

        res = described_class.call(user, watchlist.uid)
        w = res.result

        expect(res).to be_success

        aggregate_failures 'watchlist attributes' do
          expect(w[:uid]).to eq(watchlist.uid)
          expect(w[:name]).to eq(watchlist.name)
          expect(w[:stocks]).to be_kind_of(Array)
        end
      end
    end
  end
end
