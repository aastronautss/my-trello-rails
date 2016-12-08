require 'rails_helper'

describe UserSignup do
  describe '#sign_up' do
    context 'with valid info' do
      let(:user) { Fabricate.build :user }
      let(:action) { UserSignup.new(user).sign_up }

      before do
        cust_response = double :customer, successful?: true, id: '123'
        expect(StripeWrapper::Customer).to receive(:create).and_return(cust_response)

        subs_response = double :subscription, successful?: true, id: '321'
        expect(StripeWrapper::Subscription).to receive(:create).and_return(subs_response)
      end

      it 'creates a User record' do
        expect{ action }.to change(User, :count).by(1)
      end

      it 'returns successful' do
        obj = action
        expect(obj).to be_successful
      end
    end
  end
end
