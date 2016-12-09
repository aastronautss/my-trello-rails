require 'rails_helper'

describe Payment do
  context 'associations' do
    it { should belong_to(:user) }
  end
end
