require 'rails_helper'

RSpec.describe FetchWatchlist do
  let(:user) { create(:user) }

  describe '#call' do
    context 'when watchlist is not found' do
      example do
        expect {
          described_class.new(user, Faker::Alphanumeric.alphanumeric).call
        }.to raise_exception(WatchlistNotFoundError, 'Watchlist not found')
      end
    end

    context 'when watchlist belongs to another user' do
      example do
        watchlist = create(:watchlist)

        expect {
          described_class.new(user, watchlist.uid).call
        }.to raise_exception(WatchlistNotFoundError, 'Watchlist not found')
      end
    end

    context 'when watchlist is found' do
      example do
        watchlist = create(:watchlist, user: user)

        res = described_class.new(user, watchlist.uid).call

        aggregate_failures 'watchlist attributes' do
          expect(res[:uid]).to eq(watchlist.uid)
          expect(res[:name]).to eq(watchlist.name)
          expect(res[:stocks]).to be_kind_of(Array)
        end
      end
    end
  end
end
