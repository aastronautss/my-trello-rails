require 'rails_helper'

describe Plan do
  describe '.new' do
    context 'with valid input' do
      it 'sets all the instance variables' do
        plan = Plan.new('basic')

        expect(plan.name).to eq('basic')
        expect(plan.price_per_month).to eq(0)
        expect(plan.stripe_plan_id).to eq('my_trello_basic')
      end
    end

    context 'with invalid input' do
      it 'does raises an ArgumentError' do
        expect{ Plan.new('asdf') }.to raise_error(ArgumentError)
      end
    end
  end
end
