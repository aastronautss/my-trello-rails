require 'rails_helper'

describe CommentsController do
  let!(:board) { Fabricate :board }
  let!(:list) { Fabricate :list, board: board }
  let!(:card) { Fabricate :card, list: list }

  describe 'POST create' do
    let(:action) do
      post :create,
        id: card.to_param,
        comment: { body: 'asdf' },
        format: :json
    end

    it_behaves_like 'a logged in remote action'
    it_behaves_like 'a member remote action'
    it_behaves_like 'an activated remote action'

    context 'when logged in as a member' do
      before do
        set_user
        board.add_member current_user
      end

      context 'with valid parameters' do
        it 'adds an activity to the associated card' do
          action
          activities = card.reload.activities[:items]
          expect(activities.last[:type]).to eq('comment')
        end

        it 'renders cards/show' do
          action
          expect(response).to render_template('cards/show')
        end
      end

      context 'with invalid parameters' do
        let(:action) do
          post :create,
            id: card.to_param,
            comment: { body: '' },
            format: :json
        end

        it 'does not add an activity to the associated card' do
          action
          activities = card.reload.activities[:items]
          expect(activities).to be_nil
        end

        it 'renders errors' do
          action
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  # describe 'PUT update' do
  #   let(:comment) { Fabricate :comment, card: card }

  #   let(:action) do
  #     put :update,
  #       id: comment.id,
  #       comment: { card_id: comment.card_id, body: 'changed!' },
  #       format: :json
  #   end

  #   it_behaves_like 'a logged in remote action'
  #   it_behaves_like 'a member remote action'

  #   context 'when logged in as a member' do
  #     before do
  #       set_user
  #       board.add_member current_user
  #     end

  #     context 'with valid parameters' do
  #       it 'modifies the existing record' do
  #         expect{ action }.to change{ comment.reload.body }
  #       end

  #       it 'renders :show' do
  #         action
  #         expect(response).to render_template(:show)
  #       end
  #     end

  #     context 'with invalid parameters' do
  #       let(:action) do
  #         post :create,
  #           comment: { card_id: comment.card_id, body: '' },
  #           format: :json
  #       end

  #       it 'does not modify the existing record' do
  #         expect { action }.to_not change{ comment.reload.body }
  #       end

  #       it 'renders errors' do
  #         action
  #         expect(response).to have_http_status(:unprocessable_entity)
  #       end
  #     end
  #   end
  # end
end
