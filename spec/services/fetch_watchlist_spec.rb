require 'rails_helper'

RSpec.describe FetchWatchlist do
  subject { described_class.new(watchlist_uid) }

  describe '#call' do
    context 'when watchlist is invalid' do
      let(:watchlist_uid) { nil }
      example do
        expect {
          subject.call
        }.to raise_exception(InvalidWatchlistError, 'Watchlist not found')
      end
    end

    context 'when watchlist is valid' do
      let(:watchlist_uid) { %w(a1b2c3 d4e5f6).sample }
      example do
        res = subject.call

        aggregate_failures 'watchlist attributes' do
          expect(res[:uid]).to eq(watchlist_uid)
          expect(res[:name]).to be_present
          expect(res[:stocks]).to be_kind_of(Array)
        end
      end
    end
  end
end
