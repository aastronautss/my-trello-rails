require 'rails_helper'

describe Board do
  context 'validations' do
    it { should validate_presence_of :name }
  end

  context 'associations' do
    it { should have_many(:lists).dependent(:destroy) }
    it { should have_many(:board_memberships).dependent(:destroy) }
    it { should have_many(:members).through(:board_memberships).source(:user) }
  end

  describe '#add_member' do
    let(:board) { Fabricate :board }
    let(:user) { Fabricate :user }

    context 'without existing membership' do
      let(:action) { board.add_member user }

      it 'creates a BoardMembership record' do
        expect{ action }.to change(BoardMembership, :count).by(1)
      end

      it 'associates the new record with the board' do
        expect{ action }.to change(board.members, :count).by(1)
      end

      it 'returns true' do
        expect(action).to be(true)
      end

      context 'with admin parameter' do
        it 'makes the passed-in user an admin' do
          board.add_member user, true
          expect(board.board_memberships.last.admin).to be(true)
        end
      end
    end

    context 'with existing membership' do
      let(:action) { -> { board.add_member user } }
      before { action.call }

      it 'does not create a BoardMembership record' do
        expect{ action.call }.to change(BoardMembership, :count).by(0)
      end

      it 'returns false' do
        expect(action.call).to be(false)
      end
    end
  end

  describe '#remove_member' do
    let(:board) { Fabricate :board }
    let(:user) { Fabricate :user }

    context 'when membership exists' do
      let(:action) { board.remove_member user }
      before { board.add_member user }

      it 'removes a BoardMembership record' do
        expect{ action }.to change(BoardMembership, :count).by(-1)
      end

      it 'removes the association' do
        action
        expect(board.members).to_not include(user)
      end
    end

    context 'when membership does not exist' do
      let(:action) { board.remove_member user }
      before { board.add_member Fabricate(:user) }

      it 'makes no changes to the board_memberships table' do
        expect{ action }.to change(BoardMembership, :count).by(0)
      end

      it 'returns a falsey value' do
        expect(action).to be_falsey
      end
    end
  end

  describe '#admins' do
    let(:board) { Fabricate :board }
    let(:owner) { Fabricate :user }
    let(:admin_1) { Fabricate :user }
    let(:admin_2) { Fabricate :user }
    let(:non_admin) { Fabricate :user }

    before do
      board.add_member owner, false, true
      board.add_member admin_1, true
      board.add_member admin_2, true
      board.add_member non_admin
    end

    it 'returns an array of the board\'s admins' do
      expect(board.admins).to match_array([owner, admin_1, admin_2])
    end
  end
end
