require 'rails_helper'

describe BoardsController do
  describe 'GET show' do
    let(:board) { Fabricate :board }
    let(:member) { Fabricate :user }
    let(:non_member) { Fabricate :user }
    let(:action) { get :show, id: board.id }
    before { board.add_member member }

    it_behaves_like 'a logged in action'

    context 'when viewing as a member' do
      before do
       set_user member
       action
     end

      it 'sets @board' do
        expect(assigns(:board)).to eq(board)
      end

      it 'renders :show' do
        expect(response).to render_template(:show)
      end
    end

    context 'when viewing as a non-member' do
      before do
       set_user non_member
       action
     end

     it 'sets the flash' do
       expect(flash[:danger]).to be_present
     end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET new' do
    let(:action) { get :new }
    before { set_user }

    it_behaves_like 'a logged in action'

    it 'sets @board' do
      action
      expect(assigns(:board)).to be_new_record
      expect(assigns(:board)).to be_instance_of(Board)
    end

    it 'renders :new' do
      action
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    it_behaves_like 'a logged in action' do
      let(:action) { post :create, board: Fabricate.attributes_for(:board) }
    end

    context 'with valid input' do
      let(:action) { post :create, board: Fabricate.attributes_for(:board) }
      before { set_user }

      it 'creates a Board record' do
        expect{ action }.to change(Board, :count).by(1)
      end

      it 'adds current user to new board\'s memberships' do
        action
        expect(Board.last.members).to include(current_user)
      end

      it 'makes the current user the board\'s admin' do
        action
        board = Board.last
        expect(current_user.admin_of? board).to be(true)
      end

      it 'redirects to new board\'s show page' do
        action
        expect(response).to redirect_to(board_path(Board.last))
      end
    end
  end
end
