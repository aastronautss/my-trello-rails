require 'rails_helper'

describe SubscriptionHandler do
  let(:user) { Fabricate :user, activated: true }
  let(:subscription_handler) { SubscriptionHandler.new user }

  describe '#subscribe' do
    context 'to basic' do
      let(:action) { subscription_handler.subscribe 'basic', nil }

      before do
        cust_response = double :customer, successful?: true, id: '123'
        expect(StripeWrapper::Customer).to receive(:create).and_return(cust_response)

        subs_response = double :subscription, successful?: true, id: '321'
        expect(StripeWrapper::Subscription).to receive(:create).and_return(subs_response)
      end

      it 'updates the user\'s plan' do
          expect{ action }.to change{ user.reload.plan }.to('basic')
      end

      it 'updates the user\'s stripe_customer_id' do
          expect{ action }.to change{ user.reload.stripe_customer_id }.to('123')
      end

      it 'updates the user\'s stripe_subscription_id' do
          expect{ action }.to change{ user.reload.stripe_subscription_id }.to('321')
      end

      it 'returns a successful instance' do
          action
          expect(subscription_handler).to be_successful
      end
    end

    # context 'from basic to plus' do
    #   context 'with valid card' do
    #     let(:action) { subscription_change.change plus_plan.to_param, 'abcd' }
    #     before do
    #       customer_response = double :customer, successful?: true, id: '123'
    #       expect(StripeWrapper::Customer).to receive(:create).and_return(customer_response)

    #       subscription_response = double :subscription, successful?: true, id: '321'
    #       expect(StripeWrapper::Subscription).to receive(:create).and_return(subscription_response)
    #     end

    #     it 'updates the user\'s plan' do
    #       expect{ action }.to change{ user.reload.plan_id }.to(plus_plan.id)
    #     end

    #     it 'updates the user\'s stripe_customer_id' do
    #       expect{ action }.to change{ user.reload.stripe_customer_id }
    #     end

    #     it 'returns successful instance' do
    #       action
    #       expect(subscription_change).to be_successful
    #     end
    #   end

    #   context 'with declinded card' do
    #     let(:action) { subscription_change.change plus_plan.to_param, 'abcd' }
    #     before do
    #       customer_response = double :customer, successful?: false, message: 'Card declined'
    #       expect(StripeWrapper::Customer).to receive(:create).and_return(customer_response)
    #     end

    #     it 'does not update the user\'s plan' do
    #       expect{ action }.to_not change{ user.reload.plan_id }
    #     end

    #     it 'does not update the user\'s stripe_customer_id' do
    #       expect{ action }.to_not change{ user.reload.stripe_customer_id }
    #     end

    #     it 'returns an unsuccessful instance' do
    #       action
    #       expect(subscription_change).to_not be_successful
    #     end

    #     it 'sets the message on the object' do
    #       action
    #       expect(subscription_change.message).to be_present
    #     end
    #   end
    # end
  end
end
