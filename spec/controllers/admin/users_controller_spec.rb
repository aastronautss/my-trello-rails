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
end
