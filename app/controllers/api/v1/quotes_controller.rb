module Api
  module V1
    class QuotesController < ApplicationController
      # GET /api/v1/quotes/:id
      def show
        res = FetchQuote.new(ticker).call
        render json: { quote: res }, status: :ok
      rescue Exception => e
        render json: { error: { title: e.class.to_s, code: '400', detail: e.message } }, status: :bad_request
      end

      private

      def quote_params
        params.permit(:id)
      end

      def ticker
        quote_params.fetch(:id)
      end
    end
  end
end
