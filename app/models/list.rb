class List < ActiveRecord::Base
  has_many :cards, -> { order 'position asc' }, dependent: :destroy
  belongs_to :board

  validates_presence_of :title
  validates_presence_of :board

  delegate :members, to: :board, prefix: 'board'

  def next_card_position
    (cards.maximum(:position) || 0) + 1
  end

  def normalize_card_positions
    cards.each_with_index do |card, index|
      card.update! position: index + 1
    end
  end
end
