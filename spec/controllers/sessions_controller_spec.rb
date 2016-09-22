require 'rails_helper'

describe SessionsController do
  describe 'POST create' do
    let(:user) { Fabricate :user }

    it_behaves_like 'a logged out action' do
      let(:action) do
        post :create, username: user.username, password: user.password
       end
    end

    context 'with valid credentials' do
      before do
        post :create, username: user.username, password: user.password
      end

      it 'sets the session' do
        expect(session[:user_id]).to eq(user.id)
      end

      it 'sets the flash' do
        expect(flash[:success]).to be_present
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, username: user.username, password: 'wrongpassword'
      end

      it 'does not set the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'sets the flash' do
        expect(flash[:danger]).to be_present
      end

      it 'redirects to login path' do
        expect(response).to redirect_to(login_path)
      end
    end

    context 'with nonexistent user' do
      before do
        post :create, username: 'sasquatch', password: 'wontwork'
      end

      it 'does not set the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'sets the flash' do
        expect(flash[:danger]).to be_present
      end

      it 'redirects to login path' do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE destroy' do
    before { set_user }
    let(:action) { delete :destroy }

    it_behaves_like 'a logged in action'

    it 'removes the user_id from session' do
      action
      expect(session[:user_id]).to be_nil
    end

    it 'sets the flash' do
      action
      expect(flash[:success]).to be_present
    end

    it 'redirects to root' do
      action
      expect(response).to redirect_to(root_path)
    end
  end
end
