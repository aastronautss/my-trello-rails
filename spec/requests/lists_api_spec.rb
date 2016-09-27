require 'rails_helper'

describe 'Lists API' do
  let(:board) { Fabricate :board }
  let(:user) { Fabricate :user }
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  before do
    board.add_member user
    login user
  end

  it 'shows a list' do
    list = Fabricate :list, board: board

    get list_path(list), {}, headers

    json = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(json['title']).to eq(list.title)
  end

  it 'creates a list' do
    post lists_path, { list: { title: 'abcd', board_id: board.id } }, headers

    json = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:created)
    expect(json['title']).to eq('abcd')
  end

  it 'updates a list' do
    list = Fabricate :list, board: board

    put list_path(list), { list: { title: 'changed' } }, headers

    json = JSON.parse response.body

    expect(response.content_type).to eq('application/json')
    expect(response).to have_http_status(:ok)
    expect(json['title']).to eq('changed')
  end

  it 'deletes a list' do
    list = Fabricate :list, board: board

    delete list_path(list), {}, headers

    expect(response).to have_http_status(:no_content)
  end
end
