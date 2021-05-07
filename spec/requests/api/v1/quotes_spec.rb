require 'rails_helper'

RSpec.describe 'Quotes', type: :request do
  describe '/api/v1/quotes' do
    context 'when ticker is invalid' do
      example do
        get api_v1_quote_path('ABC')

        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)

        aggregate_failures 'error attributes' do
          expect(json['error']['title']).to eq('InvalidTickerError')
          expect(json['error']['code']).to eq('400')
          expect(json['error']['detail']).to eq("'ABC' is an invalid ticker")
        end
      end
    end

    context 'when ticker is valid' do
      example do
        get api_v1_quote_path('AAPL')

        json = JSON.parse(response.body)
        expect(response).to have_http_status(200)

        aggregate_failures 'quote attributes' do
          expect(json['quote']['ticker']).to eq('AAPL')
          expect(json['quote']['company_name']).to eq('Apple Inc')
          expect(json['quote']['ticker_color']).to eq('#666666')
          expect(json['quote']['open_price']).to be_a(Float)
          expect(json['quote']['delta']).to be_a(Float)
          expect(json['quote']['current_price']).to be_a(Float)
        end
      end
    end
  end
end
