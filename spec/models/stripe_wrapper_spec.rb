require 'rails_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      card: {
        number: '4242424242424242',
        exp_month: 6,
        exp_year: 1.years.from_now.year,
        cvc: 123
      }
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      card: {
        number: '4000000000000002',
        exp_month: 6,
        exp_year: 1.years.from_now.year,
        cvc: 123
      }
    ).id
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      context 'with valid card' do
        before { Stripe.api_key = ENV['stripe_api_key'] }
        let(:response) do
          StripeWrapper::Customer.create(
            card: valid_token,
            user: Fabricate(:user)
          )
        end

        it 'charges the card successfully' do
          expect(response).to be_successful
        end

        it 'sets an id' do
          expect(response.id).to be_present
        end
      end

      context 'with invalid card' do
        before { Stripe.api_key = ENV['stripe_api_key'] }

        let(:response) do
          StripeWrapper::Customer.create(
            card: invalid_token,
            user: Fabricate(:user)
          )
        end

        it 'does not charge the card' do
          expect(response).to_not be_successful
        end

        it 'returns an error message' do
          expect(response.message).to be_present
        end
      end
    end

  end

  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card' do
        it 'charges the card successfully' do
          Stripe.api_key = ENV['stripe_api_key']

          response = StripeWrapper::Charge.create(
            amount: 999,
            card: valid_token,
            description: 'a valid charge'
          )

          expect(response).to be_successful
        end
      end

      context 'with invalid card' do
        before { Stripe.api_key = ENV['stripe_api_key'] }

        let(:response) do
          StripeWrapper::Charge.create(
            amount: 999,
            card: invalid_token,
            description: 'an invalid charge'
          )
        end

        it 'does not charge the card' do
          expect(response).to_not be_successful
        end

        it 'returns an error message' do
          expect(response.message).to be_present
        end
      end
    end
  end
end
