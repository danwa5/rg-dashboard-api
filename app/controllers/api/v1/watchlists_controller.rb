module Api
  module V1
    class WatchlistsController < ApplicationController
      # GET /api/v1/watchlists
      def index
        serializer = WatchlistSerializer.new(current_user.watchlists).serializable_hash
        render json: serializer, status: :ok
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      # GET /api/v1/watchlists/:id
      def show
        watchlist = FetchWatchlist.new(current_user, watchlist_uid).call
        serializer = WatchlistSerializer.new(watchlist).serializable_hash
        render json: serializer, status: :ok
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
