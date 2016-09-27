require 'rails_helper'

describe CommentsController do
  let!(:board) { Fabricate :board }
  let!(:list) { Fabricate :list, board: board }
  let!(:card) { Fabricate :card, list: list }

  describe 'GET index' do
    let!(:comments) { Fabricate.times 2, :comment, card: card }

    let!(:other_board) { Fabricate :board }
    let!(:other_list) { Fabricate :list, board: other_board }
    let!(:other_card) { Fabricate :card, list: other_list }
    let!(:comment_not_in_board) { Fabricate :comment, card: other_card }

    let(:action) { get :index, board_id: board.id, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
        action
      end

      it 'sets @comments' do
        expect(assigns(:comments)).to match_array(comments)
      end

      it 'does not include comments not on the board' do
        expect(assigns(:comments)).to_not include(comment_not_in_board)
      end

      it 'renders :index' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:comment) { Fabricate :comment, card: card }
    let(:action) { get :show, id: comment.id, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
        action
      end

      it 'sets @comment' do
        expect(assigns(:comment)).to eq(comment)
      end

      it 'renders :show' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST create' do
    let(:action) do
      post :create,
        comment: Fabricate.attributes_for(:comment, card_id: card.id), format: :json
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
      end

      context 'with valid parameters' do
        it 'creates a new Comment record' do
          expect{ action }.to change(Comment, :count).by(1)
        end

        it 'renders :show' do
          action
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        let(:action) { post :create,
          comment: Fabricate.attributes_for(:comment, body: ''), format: :json }

        it 'does not create a new Comment record' do
          expect{ action }.to change(Comment, :count).by(0)
        end

        it 'renders errors' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:comment) { Fabricate :comment, card: card }

    let(:action) do
      put :update,
        id: comment.id,
        comment: { card_id: comment.card_id, body: 'changed!' },
        format: :json
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
      end

      context 'with valid parameters' do
        it 'modifies the existing record' do
          expect{ action }.to change{ comment.reload.body }
        end

        it 'renders :show' do
          action
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        let(:action) do
          post :create,
            comment: { card_id: comment.card_id, body: '' },
            format: :json
        end

        it 'does not modify the existing record' do
          expect { action }.to_not change{ comment.reload.body }
        end

        it 'renders errors' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
