require 'rails_helper'

describe AdminInvitationsController do
  describe 'GET edit' do
    let(:user) do
      u = Fabricate :user
      u.create_reset_token
      u
    end

    let(:action) do
      get :edit, id: user.reset_token, email: user.email
    end

    it_behaves_like 'a logged out action'

    it 'sets @user' do
      action
      expect(assigns[:user]).to be_present
    end
  end

  describe 'PUT update' do
    let(:user) do
      u = Fabricate :user
      u.create_reset_token
      u
    end

    let(:action) do
      put :update,
        id: user.reset_token,
        email: user.email,
        user: {
          password: 'newpassword',
          password_confirmation: 'newpassword'
        }
    end

    it_behaves_like 'a logged out action'

    context 'with valid params' do
      it 'changes the user\'s password' do
        expect{ action }.to change{ user.reload.password_digest }
      end

      it 'activates the user' do
        action
        expect(user.reload.activated?).to be(true)
      end

      it 'sets the flash' do
        action
        expect(flash[:success]).to be_present
      end

      it 'redirects to login' do
        action
        expect(response).to redirect_to(login_path)
      end
    end

    context 'with invalid params' do
      let(:action) do
        put :update,
          id: user.reset_token,
          email: user.email,
          user: {
            password: '',
            password_confirmation: ''
          }
      end

      it 'does not change the user\'s password' do
        expect{ action }.to_not change{ user.reload.password_digest }
      end

      it 'does not activate the user' do
        action
        expect(user.reload.activated?).to be(false)
      end

      it 'renders :edit' do
        action
        expect(response).to render_template(:edit)
      end
    end
  end
end
