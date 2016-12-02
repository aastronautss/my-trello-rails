require 'rails_helper'

describe PasswordResetsController do
  let(:user) { Fabricate :user }

  describe 'GET new' do
    let(:action) { get :new }

    it_behaves_like 'a logged out action'
  end

  describe 'POST create' do
    let(:action) { post :create, email: user.email }
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'a logged out action'

    context 'with valid email' do
      it 'sends an email to the user' do
        action
        expect(ActionMailer::Base.deliveries.last.to).to match_array(user.email)
      end

      it 'creates a reset token' do
        action
        expect(user.reload.reset_digest).to be_present
      end

      it 'sets the flash' do
        action
        expect(flash[:info]).to be_present
      end

      it 'redirects to root' do
        action
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid email' do
      let(:action) { post :create, email: 'invalid@example.com' }
      before { action }

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets the flash' do
        expect(flash[:info]).to be_present
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET edit' do
    let(:user) { Fabricate :user, activated: true }
    let(:action) { get :edit, id: user.reset_token, email: user.email }

    before { user.create_reset_token }

    it_behaves_like 'a logged out action'

    context 'with valid token' do
      it 'sets @user' do
        action
        expect(assigns[:user]).to eq(user)
      end
    end

    context 'with expired token' do
      before { user.update_attribute :reset_sent_at, 10.days.ago }

      it 'sets the flash' do
        action
        expect(flash[:danger]).to be_present
      end

      it 'redirects to new password reset' do
        action
        expect(response).to redirect_to(new_password_reset_path)
      end
    end

    context 'with invalid token' do
      let(:action) { get :edit, id: 'abcd', email: user.email }

      it 'redirects to root' do
        action
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with unactivated user' do
      let(:user) { Fabricate :user }

      it 'redirects to root' do
        action
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
