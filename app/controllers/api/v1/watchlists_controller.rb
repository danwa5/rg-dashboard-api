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
        watchlist = FetchWatchlist.call(current_user, watchlist_uid).result
        serializer = WatchlistSerializer.new(watchlist).serializable_hash
        render json: serializer, status: :ok
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      # POST /api/v1/watchlists
      def create
        res = CreateWatchlist.call(current_user, watchlist_params)
        serializer = WatchlistSerializer.new(res.result, { params: { new_watchlist?: true }}).serializable_hash
        render json: serializer, status: :created if res.success?
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      def destroy
        watchlist = FetchWatchlist.call(current_user, watchlist_uid).result
        watchlist.destroy!
        render json: {}, status: :ok
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      private

      def watchlist_params
        params.permit(:id, :name, :stocks => []).to_h
      end

      def watchlist_uid
        watchlist_params.fetch(:id)
      end
    end
  end
end
