require 'rails_helper'

describe User do
  context 'validations' do
    it { should have_secure_password }

    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_least(2).is_at_most(25) }
    it { should validate_uniqueness_of(:username).case_insensitive }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(5) }
  end

  context 'associations' do
    it { should have_many(:board_memberships) }
    it { should have_many(:boards).through(:board_memberships) }
  end

  describe '#member_of?' do
    let(:user) { Fabricate :user }
    let(:board) { Fabricate :board }

    context 'when user is a member of the board' do
      before { board.add_member user }

      it 'returns true' do
        expect(user.member_of? board ).to be(true)
      end
    end

    context 'when use is not a member of the board' do
      it 'returns false' do
        expect(user.member_of? board ).to be(false)
      end
    end
  end

  describe '#admin_of?' do
    let(:user) { Fabricate :user }
    let(:board) { Fabricate :board }

    context 'when user is an admin' do
      before { board.add_member user, true }

      it 'returns true' do
        expect(user.admin_of? board).to be(true)
      end
    end

    context 'when user is the owner' do
      before { board.add_member user, false, true }

      it 'returns true' do
        expect(user.admin_of? board).to be(true)
      end
    end

    context 'when user is a member but not an admin' do
      before { board.add_member user }

      it 'returns false' do
        expect(user.admin_of? board).to be(false)
      end
    end

    context 'when user is not a member' do
      it 'returns false' do
        expect(user.admin_of? board).to be(false)
      end
    end
  end
end
