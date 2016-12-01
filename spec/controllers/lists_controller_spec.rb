require 'rails_helper'

describe ListsController do
  render_views

  let!(:board) { Fabricate :board }

  describe 'GET index' do
    let!(:lists) { Fabricate.times 2, :list, board: board }
    let(:other_board) { Fabricate :board }
    let!(:list_not_in_board) { Fabricate :list, board: other_board }
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

      it 'sets @lists' do
        expect(assigns(:lists)).to match_array(lists)
      end

      it 'does not include lists not on the board' do
        expect(assigns(:lists)).to_not include(list_not_in_board)
      end

      it 'renders :index' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:list) { Fabricate :list, board: board }
    let(:action) { get :show, id: list.to_param, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
        action
      end

      it 'sets @list' do
        expect(assigns(:list)).to eq(list)
      end

      it 'renders :show' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'POST create' do
    let(:action) do
      post :create,
        list: {
          title: 'asdf',
          board_id: board.to_param
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
        it 'creates a new List record' do
          expect{ action }.to change(List, :count).by(1)
        end

        it 'renders :show' do
          action
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        let(:action) do
          post :create,
            list: {
              title: '',
              board_id: board.to_param
            },
            format: :json
        end

        it 'does not create a new list member' do
          expect{ action }.to change(List, :count).by(0)
        end

        it 'renders errors' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:list) { Fabricate :list, board_id: board.id }
    let(:action) do
      put :update,
        id: list.to_param,
        list: { board_id: list.board.to_param, title: 'changed!' },
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
          expect{ action }.to change{ list.reload.title }
        end

        it 'renders :show' do
          action
          expect(response).to render_template(:show)
        end
      end

      context 'with invalid parameters' do
        let(:action) do
          put :update,
            id: list.to_param,
            list: { board_id: list.board.to_param, title: '' },
            format: :json
        end

        it 'does not modify the existing record' do
          expect { action }.to_not change{ list.reload.title }
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
    let(:action) { delete :destroy, id: list.to_param, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    it 'removes the list record' do
      set_user
      board.add_member current_user
      expect{ action }.to change(List, :count).by(-1)
    end
  end
end
