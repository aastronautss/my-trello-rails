require 'rails_helper'

describe BoardMembership do
  context 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:board_id) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:board) }
  end
end
