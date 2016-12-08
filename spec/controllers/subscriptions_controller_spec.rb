require 'rails_helper'

describe SubscriptionsController do
  describe 'POST create' do
    let(:user) { Fabricate :user, activated: true }
    let(:stripe_token) { 'abc' }

    let(:action) do
      post :create, plan_id: 'plus', stripeToken: stripe_token
    end

    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'

    context 'from basic to plus plan' do
      context 'with valid card' do
        it 'redirects to my_account' do
          result = double(:subscription_result, successful?: true)
          expect_any_instance_of(SubscriptionHandler).to receive(:subscribe).and_return(result)
          expect_any_instance_of(User).to receive(:plan).and_return('plus')

          action
          expect(response).to redirect_to(my_account_path)
        end
      end

      context 'with declined card' do
        it 'redirects to my_account' do
          result = double(:subscription_result, successful?: false, message: 'Card declined.')
          expect_any_instance_of(SubscriptionHandler).to receive(:subscribe).and_return(result)

          action
          expect(response).to redirect_to my_account_path
        end

        it 'sets the flash' do
          result = double(:subscription_result, successful?: false, message: 'Card declined.')
          expect_any_instance_of(SubscriptionHandler).to receive(:subscribe).and_return(result)

          action
          expect(flash[:danger]).to be_present
        end
      end
    end
  end
end
