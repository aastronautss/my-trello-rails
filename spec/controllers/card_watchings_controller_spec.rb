require 'rails_helper'

describe CardWatchingsController do
  describe 'POST create' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user, activated: true }
    let(:action) { post :create, id: card.to_param, format: :json }
    before do
      card.list.board.add_member user
      set_user user
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'with successful watch' do
      it 'makes the user watch the card' do
        action
        expect(user.reload).to be_watching(card)
      end

      it 'returns a 200' do
        action
        expect(response).to be_successful
      end
    end

    context 'with unsuccessful watch' do
      before { user.watch card }

      it 'creates no new CardWatching records' do
        expect{ action }.to change(CardWatching, :count).by(0)
      end

      it 'returns an unsuccessful status' do
        action
        expect(response).to_not be_successful
      end
    end
  end

  describe 'DELETE destroy' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user, activated: true }
    let(:action) { delete :destroy, id: card.to_param, format: :json }
    before do
      card.list.board.add_member user
      set_user user
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'with successful unwatch' do
      before { user.watch card }

      it 'makes the user no longer watching the card' do
        action
        expect(user.reload).to_not be_watching(card)
      end

      it 'returns successful' do
        action
        expect(response).to be_successful
      end
    end

    context 'with unsuccessful unwatch' do
      it 'returns unsuccessful' do
        action
        expect(response).to_not be_successful
      end
    end
  end
end
