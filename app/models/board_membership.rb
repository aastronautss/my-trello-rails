class BoardMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :board

  validates_presence_of :user_id
  validates_presence_of :board_id
  validates_uniqueness_of :user_id, scope: :board_id
end
