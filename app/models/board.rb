class Board < ActiveRecord::Base
  has_many :lists, dependent: :destroy
  has_many :board_memberships
  has_many :members, through: :board_memberships, foreign_key: 'user_id'
end
