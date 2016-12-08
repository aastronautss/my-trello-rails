require 'rails_helper'

describe StripeWrapper, :vcr do
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
      context 'with no card' do
        let(:response) do
          StripeWrapper::Customer.create(
            card: nil,
            user: Fabricate(:user)
          )
        end

        it 'returns successful' do
          expect(response).to be_successful
        end

        it 'sets a customer id' do
          expect(response.id).to be_present
        end
      end

      context 'with valid card' do
        before { Stripe.api_key = ENV['stripe_api_key'] }
        let(:response) do
          StripeWrapper::Customer.create(
            card: valid_token,
            user: Fabricate(:user)
          )
        end

        it 'returns successful' do
          expect(response).to be_successful
        end

        it 'sets a customer id' do
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

        it 'does not create the customer' do
          expect(response).to_not be_successful
        end

        it 'returns an error message' do
          expect(response.message).to be_present
        end
      end
    end
  end

  describe StripeWrapper::Subscription do
    describe '.create' do
      let(:user) { Fabricate :user }

      context 'with customer with no card and plus subscription' do
        let(:customer) do
          StripeWrapper::Customer.create(
            card: nil,
            user: user
          )
        end

        let(:response) do
          user.stripe_customer_id = customer.id
          StripeWrapper::Subscription.create(
            user: user,
            plan: Plan.new(:plus_monthly)
          )
        end

        it 'is not successful' do
          expect(response).to_not be_successful
        end

        it 'sets a message' do
          expect(response.message).to be_present
        end
      end

      context 'with valid card' do
        let(:customer) do
          StripeWrapper::Customer.create(
            card: valid_token,
            user: user
          )
        end

        let(:response) do
          user.stripe_customer_id = customer.id
          StripeWrapper::Subscription.create(
            user: user,
            plan: Plan.new(:plus_monthly)
          )
        end

        it 'successfully creates a new subscription' do
          expect(response).to be_successful
        end

        it 'sets an id' do
          expect(response.id).to be_present
        end
      end

      # context 'with declined card' do
      #   let(:customer) do
      #     StripeWrapper::Customer.create(
      #       card: invalid_token,
      #       user: user
      #     )
      #   end

      #   let(:response) do
      #     user.stripe_customer_id = customer.id
      #     StripeWrapper::Subscription.create(
      #       user: user,
      #       plan: Fabricate(:plus_plan)
      #     )
      #   end

      #   it 'does not create a new subscription' do
      #     expect(response).to_not be_successful
      #   end
      # end
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
