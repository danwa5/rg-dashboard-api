require 'rails_helper'

RSpec.describe UpdateWatchlist do
  let(:watchlist) { create(:watchlist, stocks: %w(NVDA COIN)) }

  describe '.call' do
    context 'when command results in failure' do
      example do
        allow(watchlist).to receive(:save!).and_raise('error message')

        expect {
          described_class.call(watchlist, { name: 'My Watchlist' })
        }.to raise_error(WatchlistError, 'error message')
      end
    end

    context 'when command results in success' do
      example do
        res = described_class.call(watchlist, { name: 'My Watchlist', new_stocks: ['', 'TSLA', 'SQ', 'COIN'] })

        expect(res).to be_success
        expect(watchlist.name).to eq('My Watchlist')
        expect(watchlist.stocks).to eq(%w(COIN NVDA SQ TSLA))
      end
    end
  end
end
