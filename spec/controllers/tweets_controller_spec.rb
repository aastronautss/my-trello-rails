require 'rails_helper'

describe TweetsController do
  describe 'POST create', :vcr do
    let(:action) { post :create, tweet: { status: 'hello' }, format: :json }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'an activated remote action'

    context 'with valid input'

    context 'with invalid input'
  end
end
