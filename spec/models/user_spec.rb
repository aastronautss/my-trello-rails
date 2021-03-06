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
    it { should have_many(:services) }
    it { should have_many(:payments) }
    it { should have_many(:card_watchings) }
    it do
      should have_many(:watched_cards).
        through(:card_watchings).
        source(:card)
    end
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

  describe '#activate!' do
    let(:user) { Fabricate :user }
    before { user.activate! }

    it 'sets #activated to true' do
      expect(user.activated?).to be(true)
    end

    it 'sets #activated_at' do
      expect(user.activated_at).to be_present
    end
  end

  # ====---------------------------====
  # Password Resets
  # ====---------------------------====

  describe '#create_reset_token' do
    let(:user) { Fabricate :user, activated: true }
    before { user.create_reset_token }

    it 'sets #reset_token' do
      expect(user.reset_token).to be_present
    end

    it 'sets #reset_digest' do
      expect(user.reset_digest).to be_present
      expect(user.authenticated? :reset, user.reset_token).to be(true)
    end

    it 'sets #reset_sent_at' do
      expect(user.reset_sent_at).to be_present
    end
  end

  describe '#generate_temporary_password' do
    let(:user) { Fabricate :user }
    let(:action) { user.generate_temporary_password }

    it 'changes the user\'s password' do
      expect{ action }.to change{ user.reload.password }
    end
  end

  # ====---------------------------====
  # Services
  # ====---------------------------====

  describe '#linked_to?' do
    let(:user) { Fabricate :user, activated: true }

    context 'when user is linked to a service' do
      it 'returns true' do
        Service.create user: user, provider: 'twitter', remote_id: '123', token: 'abc', secret: 'abc123'
        expect(user.reload.linked_to? 'twitter').to eq(true)
      end
    end

    context 'when user is not linked to a service' do
      it 'returns false' do
        expect(user.reload.linked_to? 'twitter').to eq(false)
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

  # ====---------------------------====
  # Card Watching
  # ====---------------------------====

  describe '#watch' do
    let(:user) { Fabricate :user, activated: true }
    let(:card) { Fabricate :card }

    context 'when user is not already watching the card' do
      it 'watches the card' do
        user.watch card
        expect(user.reload).to be_watching(card)
      end
    end

    context 'when user is already watching the card' do
      it 'returns false' do
        user.watch card
        expect(user.watch card).to be(false)
      end
    end
  end

  describe '#unwatch' do
    let(:user) { Fabricate :user, activated: true }
    let(:card) { Fabricate :card }

    context 'when user is watching the card' do
      before { user.watch card }

      it 'unwatches the card' do
        user.unwatch card
        expect(user.reload).to_not be_watching(card)
      end
    end

    context 'when user is not watching the card' do
      it 'returns false' do
        expect(user.unwatch card).to be(false)
      end
    end
  end
end
