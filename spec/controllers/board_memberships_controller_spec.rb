require 'rails_helper'

describe BoardMembershipsController do
  describe 'POST create' do
    let(:board) { Fabricate(:board) }
    let(:new_member) { Fabricate(:user) }
    let(:action) do
      post :create,
        id: board.to_param,
        username: new_member.username
    end

    it_behaves_like 'a logged in action'
    it_behaves_like 'an admin action'

    context 'when new member exists' do
      before do
        set_user
        board.add_member current_user, true
      end

      it 'creates a BoardMembership record' do
        expect{ action }.to change(BoardMembership, :count).by(1)
      end

      it 'sets the flash' do
        action
        expect(flash[:success]).to be_present
      end

      it 'redirects to board\'s show page' do
        action
        expect(response).to redirect_to(board_path board)
      end
    end

    context 'when new member does not exist' do
      let(:action) do
        post :create,
          id: board.to_param,
          username: 'gandalf'
        end

      before do
        set_user
        board.add_member current_user, true
      end

      it 'does not create a BoardMembership record' do
        expect{ action }.to change(BoardMembership, :count).by(0)
      end

      it 'sets the flash' do
        action
        expect(flash[:danger]).to be_present
      end

      it 'redirects to board\'s show page' do
        action
        expect(response).to redirect_to(board_path board)
      end
    end

    context 'when the new member is already a member' do
      before do
        set_user
        board.add_member current_user, true
        board.add_member new_member
      end

      it 'does not create a BoardMembership record' do
        expect{ action }.to change(BoardMembership, :count).by(0)
      end

      it 'sets the flash' do
        action
        expect(flash[:danger]).to be_present
      end

      it 'redirect to board\'s show page' do
        action
        expect(response).to redirect_to(board_path board)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:board) { Fabricate :board }
    let(:to_delete) { Fabricate :user }
    let(:action) do
      delete :destroy,
        id: board.to_param,
        username: to_delete.username
    end
    before { board.add_member to_delete }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an admin action'

    context 'when the membership exists' do
      before do
        set_user
        board.add_member current_user, true
      end

      it 'removes a BoardMembership record' do
        expect{ action }.to change(BoardMembership, :count).by(-1)
      end

      it 'makes it so the user is no longer a member of the board' do
        action
        expect(to_delete.member_of? board).to be(false)
      end

      it 'redirects to board\'s show page' do
        action
        expect(response).to redirect_to(board_path board)
      end
    end
  end
end
