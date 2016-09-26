require 'spec_helper'

describe ListsController do
  render_views

  let(:board) { Fabricate :board }

  describe 'GET index' do
    let(:lists) { Fabricate.times 2, :list, board_id: board.id }
    let(:list_not_in_board) { Fabricate :list }
    let(:action) { get :index, board_id: board.id, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    it 'sets @lists'

    it 'does not include lists not on the board'

    it 'renders :index'
  end

  describe 'GET show' do
    let(:list) { Fabricate :list, board_id: board.id }
    let(:action) { get :show, id: list.id, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    it 'sets @list'

    it 'renders :show'
  end

  describe 'POST create' do
    let(:action) { post :create, # board_id: board.id,
      list: Fabricate.attributes_for(:list), format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    context 'with valid parameters' do
      it 'creates a new List record'
      it 'renders :show'
    end

    context 'with invalid parameters' do
      let(:action) { post :create, board_id: board.id,
        list: Fabricate.attributes_for(:list, title: ''), format: :json }

      it 'does not create a new list member'

      it 'renders errors'
    end
  end

  describe 'PATCH update' do
    let(:list) { Fabricate :list, board_id: board.id }
    let(:action) do
      patch :update,
        list: { id: list.id, board_id: list.board_id, title: 'changed!' },
        format: :json
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    context 'with valid parameters' do
      it 'modifies the existing record'
      it 'renders :show'
    end

    context 'with invalid parameters' do
      let(:action) do
        post :create,
          list: Fabricate.attributes_for(:list, title: ''),
          format: :json
      end

      it 'does not modify the existing record'
      it 'renders errors'
    end
  end

  describe 'DELETE destroy' do
    let(:list) { Fabricate :list, board_id: board.id }
    let(:action) { delete :destroy, id: list.id, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'

    it 'removes the list record'
  end
end
