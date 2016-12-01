shared_examples 'a logged out action' do
  before { set_user }

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
  before { clear_current_user }

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

shared_examples 'a logged in remote action' do
  before do
    clear_current_user
    action
  end

  context 'when not logged in' do
    it 'returns a 403' do
      expect(response).to have_http_status(:forbidden)
    end
  end
end

shared_examples 'an activated action' do
  before do
    set_user activated: false
    action
  end

  context 'when logged in as an unactivated user' do
    it 'sets the flash' do
      expect(flash[:danger]).to be_present
    end

    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end
end

# Prerequisites: Must have a `board` variable and an `action` variable to be
# within the scope of this call.
shared_examples 'a member action' do
  before do
    set_user
    action
  end

  context 'when logged in as a non-member' do
    it 'sets the flash' do
      expect(flash[:danger]).to be_present
    end

    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end
end

# Prerequisites: Must have a `board` variable and an `action` variable to be
# within the scope of this call.
shared_examples 'a member remote action' do
  before do
    set_user
    action
  end

  context 'when logged in as a non-member' do
    it 'returns a 403' do
      expect(response).to have_http_status(:forbidden)
    end
  end
end

shared_examples 'an admin action' do
  context 'when logged in as a non-admin member' do
    let(:board) { Fabricate :board }
    before do
      set_user
      board.add_member current_user
      action
    end

    it 'sets the flash' do
      expect(flash[:danger]).to be_present
    end

    it 'redirects to root' do
      expect(response).to redirect_to(root_path)
    end
  end
end
