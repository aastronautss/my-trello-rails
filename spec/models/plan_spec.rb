require 'rails_helper'

describe Plan do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price_per_month) }
  end

  context 'associations' do
    it { should have_many(:users) }
  end
end
