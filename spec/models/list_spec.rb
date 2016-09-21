require 'rails_helper'

describe List do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:board) }
  end

  context 'associations' do
    it { should have_many(:cards).dependent(:destroy) }
    it { should belong_to(:board) }
  end
end
