require 'spec_helper'

describe ListController do
  let(:board) { Fabricate :board }

  describe 'GET index' do
    let(:lists) { Fabricate.times 2, :list, board_id: board.id }
    let(:list_not_in_board) { Fabricate :list }
    let(:action) { get :index, board_id: board.id }

    it_behaves_like 'a logged in action'
    it_behaves_like 'a member action'

    it 'sets @lists'

    it 'does not include lists not on the board'

    it 'renders :index'
  end

  describe 'GET show' do
    let(:list) { Fabricate :list, board_id: board.id }
    let(:action) { get :show, id: list.id }

    it_behaves_like 'a logged in action'
    it_behaves_like 'a member action'

    it 'sets @list'

    it 'renders :show'
  end

  describe 'POST create' do
    let(:action) { post :create, board_id: board.id,
      list: Fabricate.attributes_for(:list) }

    it_behaves_like 'a logged in action'
    it_behaves_like 'a member action'

    context 'with valid parameters' do
      it 'creates a new List record'
      it 'renders :show'
    end

    context 'with invalid parameters' do
      let(:action) { post :create, board_id: board.id,
        list: Fabricate.attributes_for(:list, title: '') }

      it 'does not create a new list member'

      it 'renders errors'
    end
  end

  describe 'DELETE destroy' do
    let(:list) { Fabricate :list, board_id: board.id }
    let(:action) { delete :destroy, id: list.id }

    it_behaves_like 'a logged in action'
    it_behaves_like 'a member action'

    it 'removes the list record'
  end
end
