# require 'rails_helper'

# describe 'Comments API' do
#   let(:board) { Fabricate :board }
#   let(:list) { Fabricate :list }
#   let(:card) { Fabricate :card }
#   let(:user) { Fabricate :user }
#   let(:headers) { { 'ACCEPT' => 'application/json' } }

#   before do
#     board.add_member user
#     login user
#   end

#   it 'shows a comment' do
#     comment = Fabricate :comment, card: card

#     get comment_path(comment), {}, headers

#     json = JSON.parse response.body

#     expect(response.content_type).to eq('application/json')
#     expect(response).to have_http_status(:ok)
#     expect(json['body']).to eq("<p>#{comment.body}</p>")
#   end

#   it 'creates a comment' do
#     post comments_path, { comment: { body: 'abcd', card_id: card.id } }, headers

#     json = JSON.parse response.body

#     expect(response.content_type).to eq('application/json')
#     expect(response).to have_http_status(:created)
#     expect(json['body']).to eq('<p>abcd</p>')
#     expect(json['author']['username']).to eq(current_user.username)
#   end

#   it 'updates a comment' do
#     comment = Fabricate :comment, card: card

#     put comment_path(comment), { comment: { body: 'changed' } }, headers

#     json = JSON.parse response.body

#     expect(response.content_type).to eq('application/json')
#     expect(response).to have_http_status(:ok)
#     expect(json['body']).to eq('<p>changed</p>')
#   end

#   it 'deletes a comment' do
#     comment = Fabricate :comment, card: card

#     delete comment_path(comment), {}, headers

#     expect(response).to have_http_status(:no_content)
#   end
# end
