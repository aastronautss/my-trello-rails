require 'rails_helper'

describe Card do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:list) }
  end

  context 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:list) }
  end
end
