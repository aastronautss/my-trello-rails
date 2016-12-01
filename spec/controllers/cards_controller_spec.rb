require 'rails_helper'

describe CardsController do
  let!(:board) { Fabricate :board }

  describe 'GET index' do
    let!(:list) { Fabricate :list, board: board }
    let!(:cards) { Fabricate.times 2, :card, list: list }

    let(:other_board) { Fabricate :board }
    let!(:list_not_in_board) { Fabricate :list, board: other_board }
    let!(:card_not_in_board) { Fabricate :card, list: list_not_in_board }

    let(:action) { get :index, board_id: board.to_param, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
        action
      end

      it 'sets @cards' do
        expect(assigns(:cards)).to match_array(cards)
      end

      it 'does not include cards not on the board' do
        expect(assigns(:cards)).to_not include(card_not_in_board)
      end

      it 'renders :index' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:list) { Fabricate :list, board: board }
    let(:card) { Fabricate :card, list: list }

    let(:action) { get :show, id: card.to_param, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
        action
      end

      it 'sets @card' do
        expect(assigns(:card)).to eq(card)
      end

      it 'renders :show' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST create' do
    let!(:list) { Fabricate :list, board: board }
    let(:action) do
      post :create,
        card: {
          title: 'asdf',
          list_id: list.to_param
        },
        format: :json
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
      end

      context 'with valid parameters' do
        it 'creates a new Card record' do
          expect{ action }.to change(Card, :count).by(1)
        end

        it 'renders :show' do
          action
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        let(:action) do
          post :create,
            card: {
              title: '',
              list_id: list.to_param
            },
            format: :json
        end

        it 'does not create a new Card record' do
          expect{ action }.to change(Card, :count).by(0)
        end

        it 'renders errors' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:list) { Fabricate :list, board: board }
    let(:card) { Fabricate :card, list: list }

    let(:action) do
      put :update,
        id: card.to_param,
        card: {
          title: 'changed!',
          list_id: card.list.to_param
         },
        format: :json
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
      end

      context 'with valid parameters' do
        it 'modifies the existing record' do
          expect{ action }.to change{ card.reload.title }
        end

        it 'adds items to the card\'s activities' do
          expect{ action }.to change{ card.reload.activities[:items] }
        end

        it 'renders :show' do
          action
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        let(:action) do
          post :create,
            card: {
              list_id: card.list.to_param,
              title: ''
            },
            format: :json
        end

        it 'does not modify the existing record' do
          expect { action }.to_not change{ card.reload.title }
        end

        it 'renders errors' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:list) { Fabricate :list, board_id: board.id }
    let!(:card) { Fabricate :card, list_id: list.id }

    let(:action) { delete :destroy, id: card.to_param, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    it 'removes the list record' do
      set_user
      board.add_member current_user
      expect{ action }.to change(Card, :count).by(-1)
    end
  end
end
