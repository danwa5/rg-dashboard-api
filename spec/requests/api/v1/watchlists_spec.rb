require 'rails_helper'

RSpec.describe 'Watchlists', type: :request do
  describe 'GET /api/v1/watchlists/:id' do
    before do
      expect_any_instance_of(FetchWatchlist).to receive(:call).and_call_original
    end

    context 'when watchlist is invalid' do
      example do
        get api_v1_watchlist_path('abc')

        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)

        aggregate_failures 'error attributes' do
          expect(json['error']['title']).to eq('InvalidWatchlistError')
          expect(json['error']['code']).to eq('400')
          expect(json['error']['detail']).to eq('Watchlist not found')
        end
      end
    end

    context 'when watchlist is valid' do
      example do
        get api_v1_watchlist_path('a1b2c3')

        json = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(json['watchlist']).to be_present
      end
    end
  end
end