require 'rails_helper'

RSpec.describe FetchStock do
  subject { described_class.new(ticker) }

  describe '#call' do
    context 'when ticker is blank' do
      let(:ticker) { nil }
      example do
        expect {
          subject.call
        }.to raise_exception(InvalidTickerError, "'#{ticker}' is an invalid ticker")
      end
    end

    context 'when ticker is invalid' do
      let(:ticker) { 'ZZZ' }
      example do
        expect {
          subject.call
        }.to raise_exception(InvalidTickerError, "'#{ticker}' is an invalid ticker")
      end
    end

    context 'when ticker is lowercase' do
      let(:ticker) { 'amzn' }
      example do
        expect {
          subject.call
        }.not_to raise_exception
      end
    end

    context 'when ticker is valid' do
      let(:ticker) { 'AAPL' }
      example do
        res = subject.call

        aggregate_failures 'quote attributes' do
          expect(res[:ticker]).to eq('AAPL')
          expect(res[:company_name]).to eq('Apple Inc')
          expect(res[:ticker_color]).to eq('#666666')
          expect(res[:open_price]).to be_a(Float)
          expect(res[:delta]).to be_a(Float)
          expect(res[:current_price]).to be_a(Float)
        end
      end
    end
  end
end
