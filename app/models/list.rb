class List < ActiveRecord::Base
  has_many :cards, dependent: :destroy
  belongs_to :board

  validates_presence_of :title
  validates_presence_of :board

  delegate :members, to: :board, prefix: 'board'
end
