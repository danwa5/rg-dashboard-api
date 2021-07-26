require 'rails_helper'

RSpec.describe CreateWatchlist do
  let(:user) { create(:user) }

  describe '.call' do
    context 'when command results in failure' do
      before do
        create(:watchlist, user: user, name: 'My Watchlist')
      end
      example do
        expect {
          described_class.call(user, { name: 'My Watchlist', stocks: nil })
        }.to raise_error(WatchlistError, 'A watchlist with the same name already exists')
      end
    end

    context 'when command results in success' do
      example do
        res = described_class.call(user, { name: 'My Watchlist', stocks: %w(AAPL AMZN SHOP) })
        watchlist = res.result

        expect(res).to be_success
        expect(watchlist.name).to eq('My Watchlist')
        expect(watchlist.stocks).to contain_exactly('AAPL', 'AMZN', 'SHOP')
      end
    end
  end
end
