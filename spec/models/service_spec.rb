require 'rails_helper'

describe Service do
  context 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:remote_id) }
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:user) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end
end
