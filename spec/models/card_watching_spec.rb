require 'rails_helper'

describe CardWatching do
  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:card) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:card) }
  end
end
