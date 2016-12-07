require 'rails_helper'

describe SubscriptionChange do
  let(:user) { Fabricate :user, activated: true }
  let(:subscription_change) { SubscriptionChange.new user }

  describe '#change' do
    let(:plus_plan) { Fabricate :plus_plan }

    context 'from basic to plus' do
      context 'with valid card info' do
        let(:action) { subscription_change.change plus_plan.to_param, 'abcd' }
        before do
          response = double :customer, successful?: true, id: '123'
          expect(StripeWrapper::Customer).to receive(:create).and_return(response)
        end

        it 'updates the user\'s plan' do
          expect{ action }.to change{ user.reload.plan_id }.to(plus_plan.id)
        end

        it 'updates the user\'s stripe_customer_id' do
          expect{ action }.to change{ user.reload.stripe_customer_id }
        end

        it 'returns successful instance' do
          action
          expect(subscription_change).to be_successful
        end
      end
    end
  end
end
