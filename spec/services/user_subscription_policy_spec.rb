require 'rails_helper'

describe UserSubscriptionPolicy do
  describe '#basic?' do
    context 'when user is at an equal level' do
      let(:user) { Fabricate :user, activated: true, plan: 'basic' }

      it 'returns true' do
        expect(UserSubscriptionPolicy.new(user).basic?).to be(true)
      end
    end

    context 'when user is at a higher level' do
      let(:user) { Fabricate :user, activated: true, plan: 'basic' }

      it 'returns true' do
        expect(UserSubscriptionPolicy.new(user).basic?).to be(true)
      end
    end
  end

  describe '#plus?' do
    context 'when user is at a lower level' do
      let(:user) { Fabricate :user, activated: true, plan: 'basic' }

      it 'returns false' do
        expect(UserSubscriptionPolicy.new(user).plus?).to be(false)
      end
    end

    context 'when user is at an equal level' do
      let(:user) { Fabricate :user, activated: true, plan: 'plus_monthly' }

      it 'returns true' do
        expect(UserSubscriptionPolicy.new(user).plus?).to be(true)
      end
    end
  end
end
