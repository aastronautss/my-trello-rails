require 'rails_helper'

describe AccountActivationsController do
  describe 'GET edit' do
    let(:user) { Fabricate :user }
    let(:action) do
      get :edit, id: user.activation_token, email: user.email
    end

    it_behaves_like 'a logged out action'

    context 'when account has not yet been activated' do
      context 'with valid activation token' do
        before { action }

        it 'activates the user' do
          expect(user.reload.activated?).to be(true)
        end

        it 'logs in the user' do
          expect(session[:user_id]).to eq(user.id)
        end

        it 'sets the flash' do
          expect(flash[:success]).to be_present
        end

        it 'redirects to root' do
          expect(response).to redirect_to(root_path)
        end
      end

      context 'with invalid activation token' do
        let(:action) do
          get :edit, id: 'abcd', email: user.email
        end

        before { action }

        it 'does not activate the user' do
          expect(user.reload.activated?).to be(false)
        end

        it 'does not log in the user' do
          expect(session[:user_id]).to be_nil
        end

        it 'sets the flash' do
          expect(flash[:danger]).to be_present
        end
      end
    end

    context 'when account has been activated' do
      before do
        user.activate!
        action
      end

      it 'does not log in the user' do
        expect(session[:user_id]).to be_nil
      end

      it 'sets the flash' do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
