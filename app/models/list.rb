class List < ActiveRecord::Base
  has_many :cards, dependent: :destroy

  belongs_to :board
end
