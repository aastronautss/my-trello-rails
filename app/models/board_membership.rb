class BoardMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :board

  validates_uniqueness_of :user, scope: :board
end
