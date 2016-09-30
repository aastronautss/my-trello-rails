require 'rails_helper'

describe Card do
  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:list) }

    it { should serialize(:activities).as(HashSerializer) }
  end

  context 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:list) }
  end

  describe '#add_activity' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }
    let(:action) { card.add_activity 'edited the description.', user }

    context 'with NULL activity column' do
      it 'adds an "items" attribute to the object' do
        action
        expect(card.reload.activities[:items]).to be_instance_of(Array)
      end

      it 'adds activity to the "items" array' do
        action
        activities = card.reload.activities[:items]
        expect(activities.last[:text]).to eq('edited the description.')
      end
    end

    context 'with existing activity column' do
      before { card.add_activity 'edited the title.', user }

      it 'adds the new activity to the "items" array' do
        expect{ action }.to change{ card.reload.activities[:items].size }.by(1)
      end
    end
  end
end
