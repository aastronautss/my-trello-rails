require 'rails_helper'

describe Admin::UsersController do
  describe 'GET index' do
    let(:user) { Fabricate :user, system_admin: true, activated: true }
    let(:action) { get :index }
    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'
    it_behaves_like 'a system admin action'

    it 'sets @users' do
      action
      expect(assigns[:users]).to be_present
    end
  end

  describe 'GET new' do
    let(:user) { Fabricate :user, system_admin: true, activated: true }
    let(:action) { get :new }
    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'
    it_behaves_like 'a system admin action'

    it 'sets @user' do
      action
      expect(assigns[:user]).to be_instance_of(User)
      expect(assigns[:user]).to be_new_record
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate :user, system_admin: true, activated: true }
    let(:action) do
      post :create, user: {
        username: 'alice',
        email: 'alice@example.com'
      }
    end

    before { set_user user }
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'
    it_behaves_like 'a system admin action'

    it 'sets @user' do
      action
      expect(assigns[:user]).to be_instance_of(User)
    end

    context 'with valid input' do
      it 'sets the user\'s password' do
        action
        expect(User.last.password_digest).to be_present
      end

      it 'creates a User record' do
        expect{ action }.to change(User, :count).by(1)
      end

      it 'emails the new user' do
        action
        expect(ActionMailer::Base.deliveries.last.to).to contain_exactly(User.last.email)
      end

      it 'redirects to :users' do
        action
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'with invalid input' do
      let(:action) do
        post :create, user: {
          username: '',
          email: 'alice@example.com'
        }
      end

      it 'does not create a User record' do
        expect{ action }.to change(User, :count).by(0)
      end

      it 'does not email the user' do
        action
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders :new' do
        action
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:user) { Fabricate :user, activated: true, system_admin: true }
    let!(:user_to_delete) { Fabricate :user, activated: true }

    let(:action) do
      delete :destroy, id: user_to_delete.to_param
    end

    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'
    it_behaves_like 'a system admin action'

    it 'removes the User record' do
      expect{ action }.to change(User, :count).by(-1)
    end

    it 'sets the flash' do
      action
      expect(flash[:info]).to be_present
    end

    it 'redirects to :index' do
      action
      expect(response).to redirect_to(admin_users_path)
    end
  end
end
