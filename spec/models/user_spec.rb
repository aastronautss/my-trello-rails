require 'rails_helper'

describe User do
  context 'validations' do
    it { should have_secure_password }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(2).is_at_most(25) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:email).is_at_most(255) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(5) }
  end

  context 'associations' do
    it { should have_many(:board_memberships) }
    it { should have_many(:boards).through(:board_memberships) }
  end

  # ====---------------------------====
  # Authentication and Passwords
  # ====---------------------------====

  describe '#remember' do
    let(:user) { Fabricate :user }

    it 'populates the user\'s remember_digest' do
      user.remember
      expect(user.remember_digest).to be_present
    end
  end

  describe '#authenticated?' do
    let(:user) { Fabricate :user }

    context 'with remember_digest set' do
      before { user.remember }

      context 'with correct token' do
        it 'returns true' do
          remember_token = user.remember_token
          expect(user.authenticated?(:remember, remember_token)).to be(true)
        end
      end

      context 'with incorrect token' do
        it 'returns false' do
          remember_token = 'abcd'
          expect(user.authenticated?(:remember, remember_token)).to be(false)
        end
      end
    end

    context 'with no remember_digest set' do
      context 'with no token given' do
        it 'returns false' do
          expect(user.authenticated?(:remember, nil)).to be(false)
        end
      end

      context 'with a token given' do
        it 'returns false' do
          expect(user.authenticated?(:remember, 'abcd')).to be(false)
        end
      end
    end
  end

  # ====---------------------------====
  # Board Membership
  # ====---------------------------====

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
