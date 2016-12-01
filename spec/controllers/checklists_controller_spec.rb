require 'rails_helper'

describe ChecklistsController do
  describe 'POST create' do
    let(:card) { Fabricate :card }
    let(:action) do
      post :create,
        checklist: { title: 'A checklist' },
        card_id: card.to_param,
        format: :json
    end

    before { set_user }

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'an activated remote action'

    context 'with valid input' do
      it 'creates a new checklist' do
        action
        expect(card.reload.checklists[:lists].size).to eq(1)
      end

      it 'returns a 200' do
        action
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid input' do
      let(:action) do
        post :create,
        checklist: { title: '' },
        card_id: card.to_param,
        format: :json
      end

      it 'does not create a new checklist' do
        action
        expect(card.reload.checklists[:lists]).to be_nil
      end

      it 'returns a 422' do
        action
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
