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

      it 'defaults to "log" type' do
        action
        activity = card.reload.activities[:items].last
        expect(activity[:type]).to eq('log')
      end
    end

    context 'with existing activity column' do
      before { card.add_activity 'edited the title.', user }

      it 'adds the new activity to the "items" array' do
        expect{ action }.to change{ card.reload.activities[:items].size }.by(1)
      end
    end

    context 'with invalid type' do
      let(:action) { card.add_activity 'this won\'t work', user, type: :bork }

      it 'returns false' do
        expect(action).to be(false)
      end
    end

    context 'with empty text' do
      let(:action) { card.add_activity '', user }

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  describe '#add_comment' do
    let(:card) { Fabricate :card }
    let(:user) { Fabricate :user }
    let(:action) { card.add_comment 'This is a comment', user }

    it 'adds an activity' do
      action
      expect(card.activities[:items].size).to eq(1)
    end

    it 'makes the new activity a comment type' do
      action
      activity = card.reload.activities[:items].last
      expect(activity[:type]).to eq('comment')
    end

    context 'with empty text' do
      let(:action) { card.add_comment '', user }

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end
end
