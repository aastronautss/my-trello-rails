shared_examples 'a logged out action' do
  before(:each) { set_user }

  context 'when logged in' do
    it 'redirects to root' do
      action
      expect(response).to redirect_to(root_path)
    end

    it 'sets the flash' do
      action
      expect(flash[:danger]).to be_present
    end
  end
end

shared_examples 'a logged in action' do
  before(:each) { clear_current_user }

  context 'when not logged in' do
    it 'redirects to root' do
      action
      expect(response).to redirect_to(root_path)
    end

    it 'sets the flash' do
      action
      expect(flash[:danger]).to be_present
    end
  end
end
