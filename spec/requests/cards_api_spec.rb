require 'rails_helper'

describe 'Cards API' do
  let(:board) { Fabricate :board }
  let(:list) { Fabricate :list }
  let(:user) { Fabricate :user }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  before do
    board.add_member user
    login user
  end

  it 'shows a card' do
    card = Fabricate :card, list: list

    get card_path(card), {}, headers

    json = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(json['title']).to eq(card.title)
  end

  it 'creates a card' do
    post cards_path, { card: { title: 'abcd', list_id: list.to_param } }, headers

    json = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:created)
    expect(json['title']).to eq('abcd')
  end

  it 'updates a card' do
    card = Fabricate :card, list: list

    put card_path(card), { card: { title: 'changed' } }, headers

    json = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(json['title']).to eq('changed')
  end

  it 'deletes a card' do
    card = Fabricate :card, list: list

    delete card_path(card), {}, headers

    expect(response).to have_http_status(:no_content)
  end
end
