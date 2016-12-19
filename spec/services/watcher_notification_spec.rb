require 'rails_helper'

describe WatcherNotification do
  describe '.new' do
    context 'when object does not have watchers' do
      it 'raises an error' do
        user = Fabricate :user
        expect{ WatcherNotification.new(user) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#notify' do
    let!(:card) { Fabricate :card }
    let(:watchers) { Fabricate.times (rand(5) + 1), :user }

    before { watchers.each { |user| user.watch card } }
    after { ActionMailer::Base.deliveries.clear }

    context 'with no current_user given' do
      let(:notifier) { WatcherNotification.new(card) }
      let(:action) { notifier.notify('this is a subject', 'this is a msg') }

      it 'sends an email to each watcher' do
        action
        expect(ActionMailer::Base.deliveries.count).to eq(watchers.count)
      end
    end

    context 'with current user given' do
      let(:user) { Fabricate :user }
      let(:notifier) { WatcherNotification.new(card, current_user: user) }
      let(:action) { notifier.notify('this is a subject', 'this is a msg') }
      before { user.watch card }

      it 'does not send an email to the current user' do
        action
        expect(ActionMailer::Base.deliveries.count).to eq(watchers.count)
      end
    end
  end
end
