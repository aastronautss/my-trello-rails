class CardWatching < ActiveRecord::Base
  belongs_to :user
  belongs_to :card

  validates_presence_of :user
  validates_presence_of :card
end
