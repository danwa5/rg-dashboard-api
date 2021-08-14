require 'rails_helper'

RSpec.describe 'Watchlists', type: :request do
  let(:user) { create(:user) }

  before do
    allow(AuthorizeApiRequest).to receive_message_chain(:call, :result).and_return(user)
  end

  describe 'GET /api/v1/watchlists' do
    before do
      create_list(:watchlist, 3, user: user)
    end
    example do
      get api_v1_watchlists_path

      json = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(json['data'].count).to eq(3)
    end
  end

  describe 'GET /api/v1/watchlists/:id' do
    context 'when request raises exception' do
      example do
        expect(FetchWatchlist).to receive(:call).and_call_original

        get api_v1_watchlist_path('abc')

        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)

        aggregate_failures 'error attributes' do
          expect(json['error']['title']).to eq('WatchlistNotFoundError')
          expect(json['error']['code']).to eq('400')
          expect(json['error']['detail']).to eq('Watchlist not found')
        end
      end
    end

    context 'when request is successful' do
      example do
        watchlist = create(:watchlist, user: user)

        expect(FetchWatchlist).to receive_message_chain(:call, :result).and_return(watchlist)

        get api_v1_watchlist_path(watchlist.uid)

        json = JSON.parse(response.body)
        res = json['data']

        expect(response).to have_http_status(200)
        expect(res['id']).to eq(watchlist.uid)
        expect(res['type']).to eq('watchlist')
        expect(res['attributes']['name']).to eq(watchlist.name)
        expect(res['attributes']['stocks'].map{ |s| s['ticker'] }).to eq(watchlist.stocks)
      end
    end
  end

  describe 'POST /api/v1/watchlists' do
    context 'when request raises exception' do
      example do
        params = { name: 'My Watchlist' }
        expect(CreateWatchlist).to receive(:call).with(user, params).and_raise(RuntimeError, 'An error message')

        post api_v1_watchlists_path, params: params

        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)

        aggregate_failures 'error attributes' do
          expect(json['error']['title']).to eq('RuntimeError')
          expect(json['error']['code']).to eq('400')
          expect(json['error']['detail']).to eq('An error message')
        end
      end
    end

    context 'when request is successful' do
      example do
        params = { name: 'My Watchlist', stocks: %w(TSLA COIN) }
        expect(CreateWatchlist).to receive(:call).with(user, params).and_call_original

        post api_v1_watchlists_path, params: params

        json = JSON.parse(response.body)
        res = json['data']
        watchlist = Watchlist.last

        expect(response).to have_http_status(201)
        expect(res['id']).to eq(watchlist.uid)
        expect(res['type']).to eq('watchlist')
        expect(res['attributes']['name']).to eq(watchlist.name)
        expect(res['attributes']['stocks']).to eq(watchlist.stocks)
      end
    end
  end

  describe 'PATCH /api/v1/watchlists/:id' do
    let(:watchlist) { create(:watchlist) }
    let(:params) { { name: 'My Top Picks', add_stocks: %w(SQ ETSY), remove_stocks: %w(BIGC)} }

    context 'when request raises exception' do
      example do
        expect(FetchWatchlist).to receive(:call).and_raise(WatchlistNotFoundError, 'An error message')

        patch api_v1_watchlist_path('abc'), params: params

        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)

        aggregate_failures 'error attributes' do
          expect(json['error']['title']).to eq('WatchlistNotFoundError')
          expect(json['error']['code']).to eq('400')
          expect(json['error']['detail']).to eq('An error message')
        end
      end
    end

    context 'when request is successful' do
      example do
        expect(FetchWatchlist).to receive_message_chain(:call, :result).and_return(watchlist)
        expect(UpdateWatchlist).to receive(:call).with(watchlist, params).and_return(double(success?: true))

        patch api_v1_watchlist_path('abc'), params: params

        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /api/v1/watchlists/:id' do
    context 'when request raises exception' do
      example do
        expect(FetchWatchlist).to receive_message_chain(:call, :result).and_raise(WatchlistNotFoundError, 'An error message')

        expect {
          delete api_v1_watchlist_path('abc')
        }.not_to change(Watchlist, :count)

        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)

        aggregate_failures 'error attributes' do
          expect(json['error']['title']).to eq('WatchlistNotFoundError')
          expect(json['error']['code']).to eq('400')
          expect(json['error']['detail']).to eq('An error message')
        end
      end
    end

    context 'when request is successful' do
      example do
        watchlist = create(:watchlist, user: user)
        expect(FetchWatchlist).to receive_message_chain(:call, :result).and_return(watchlist)

        expect {
          delete api_v1_watchlist_path('abc')
        }.to change(Watchlist, :count).by(-1)

        expect(response).to have_http_status(200)
      end
    end
  end
end
