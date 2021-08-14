require 'rails_helper'

RSpec.describe UpdateWatchlist do
  let(:watchlist) { create(:watchlist, stocks: %w(NVDA COIN AAPL)) }

  describe '.call' do
    context 'when command results in failure' do
      example do
        allow(watchlist).to receive(:save!).and_raise('error message')

        expect {
          described_class.call(watchlist, { name: 'My Watchlist' })
        }.to raise_error(WatchlistError, 'error message')
      end
    end

    context 'when params contains stocks to add' do
      example do
        res = described_class.call(watchlist, { name: 'My Watchlist', add_stocks: ['', 'TSLA', 'SQ', 'COIN'] })

        expect(res).to be_success
        expect(watchlist.name).to eq('My Watchlist')
        expect(watchlist.stocks).to eq(%w(AAPL COIN NVDA SQ TSLA))
      end
    end

    context 'when params contains stocks to remove' do
      example do
        res = described_class.call(watchlist, { name: 'My Watchlist', remove_stocks: ['AAPL', 'NVDA', 'FOOBAR'] })

        expect(res).to be_success
        expect(watchlist.name).to eq('My Watchlist')
        expect(watchlist.stocks).to eq(%w(COIN))
      end
    end

    context 'when params contains stocks to add and remove' do
      example do
        res = described_class.call(watchlist, { name: 'My Watchlist', add_stocks: ['SQ'], remove_stocks: ['COIN'] })

        expect(res).to be_success
        expect(watchlist.name).to eq('My Watchlist')
        expect(watchlist.stocks).to eq(%w(AAPL NVDA SQ))
      end
    end
  end
end
