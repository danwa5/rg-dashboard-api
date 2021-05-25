module Api
  module V1
    class WatchlistsController < ApplicationController
      # GET /api/v1/watchlists
      def index
        res = $WATCHLISTS.to_a.map do |w|
          {
            uid: w[0],
            name: w[1]['name'],
          }
        end

        render json: { watchlists: res }, status: :ok
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      # GET /api/v1/watchlists/:id
      def show
        res = FetchWatchlist.new(watchlist_uid).call
        render json: { watchlist: res }, status: :ok
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      private

      def watchlist_params
        params.permit(:id)
      end

      def watchlist_uid
        watchlist_params.fetch(:id)
      end
    end
  end
end
