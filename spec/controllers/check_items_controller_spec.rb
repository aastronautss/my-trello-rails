require 'rails_helper'

describe CheckItemsController do
  describe 'POST create' do
    let(:card) { Fabricate :card }
    let(:action) do
      post :create,
        check_item: { name: 'A check item' },
        card_id: card.to_param,
        checklist_id: 0,
        format: :json
      end

    before do
      set_user
      card.add_checklist Faker::Lorem.words(4).join(' '), current_user
    end

    it_behaves_like 'a logged in remote action'

    context 'with valid input' do
      it 'creates a new check_item' do
        action
        expect(card.reload.checklists[:lists][0][:check_items].size).to eq(1)
      end

      it 'returns a 200' do
        action
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid input' do
      let(:action) do
        post :create,
          check_item: { name: '' },
          card_id: card.to_param,
          checklist_id: 0,
          format: :json
      end

      it 'does not create a new check_item' do
        action
        expect(card.reload.checklists[:lists][0][:check_items].size).to eq(0)
      end

      it 'returns a 422' do
        action
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:card) { Fabricate :card }
    let(:action) do
      delete :destroy,
        format: :json,
        card_id: card.to_param,
        checklist_id: 0,
        id: 0
    end

    before do
      set_user
      card.add_checklist 'A checklist', current_user
      card.add_check_item 'A check_item', 0
    end

    it_behaves_like 'a logged in remote action'

    it 'removes the check item' do
      action
      checklist = card.reload.checklists[:lists][0]
      expect(checklist[:check_items]).to be_empty
    end
  end

  describe 'GET toggle' do
    let(:card) { Fabricate :card }
    let(:action) do
      get :toggle,
        format: :json,
        card_id: card.to_param,
        checklist_id: 0,
        id: 0
    end

    before do
      set_user
      card.add_checklist 'A checklist', current_user
      card.add_check_item 'A check_item', 0
    end

    it_behaves_like 'a logged in remote action'

    it 'toggles the check item' do
      action
      check_item = card.reload.checklists[:lists][0][:check_items][0]
      expect(check_item[:done]).to be(true)
    end
  end
end
