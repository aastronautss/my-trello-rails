require 'rails_helper'

describe UsersController do
  describe 'GET new' do
    let(:action) { get :new }

    it_behaves_like 'a logged out action'

    it 'sets @user' do
      action
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end

    it 'renders :new' do
      action
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create', :vcr do
    it_behaves_like 'a logged out action' do
      let(:action) { post :create, user: Fabricate.attributes_for(:user) }
    end

    context 'with valid input' do
      let(:action) { post :create, user: Fabricate.attributes_for(:user) }

      after { ActionMailer::Base.deliveries.clear }

      it 'sends an activation email' do
        action
        expect(ActionMailer::Base.deliveries.last.to).to match_array(User.last.email)
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

    context 'with invalid input' do
      let(:action) { post :create, user: { username: '', password: 'asdfdsa' } }

      it 'does not create a User record' do
        expect{ action }.to change(User, :count).by(0)
      end

      it 'renders :new' do
        action
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET edit' do
    let(:user) { Fabricate :user, activated: true }
    let(:action) { get :edit, id: user.username }
    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'

    it 'sets @user' do
      action
      expect(assigns[:user]).to be_present
    end
  end

  describe 'PATCH update' do
    let!(:user) { Fabricate :user, activated: true }
    let(:action) do
      patch :update,
        user: {
          password: 'asdfdsa',
          password_confirmation: 'asdfdsa'
        }
    end
    before { set_user user }

    it_behaves_like 'a logged in action'
    it_behaves_like 'an activated action'

    it 'sets @user' do
      action
      expect(assigns[:user]).to be_present
    end

    context 'with valid input' do
      it 'updates the current user\'s record' do
        expect{ action }.to change{ user.reload.password_digest }
      end

      it 'redirects to my_account' do
        action
        expect(response).to redirect_to(my_account_path)
      end

      it 'sets the flash' do
        action
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      let(:action) do
        patch :update,
          user: {
            password: 'asdfdsa',
            password_confirmation: ''
          }
      end

      it 'does not update the current user\'s record' do
        expect{ action }.to_not change{ user.reload.password_digest }
      end

      it 'renders :edit' do
        action
        expect(response).to render_template(:edit)
      end
    end
  end
end
