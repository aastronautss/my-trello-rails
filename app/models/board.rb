class Board < ActiveRecord::Base
  has_many :lists, -> { order 'position asc' }, dependent: :destroy
  has_many :board_memberships, dependent: :destroy
  has_many :members, through: :board_memberships, source: :user

  validates_presence_of :name

  def add_member(user, admin = false, owner = false)
    m = board_memberships.new user: user, admin: admin, owner: owner
    m.save
  end

  def remove_member(user)
    board_memberships.find_by(user: user).try(:destroy)
  end

  def admins
    @admins ||= board_memberships.where('admin = true OR owner = true').
                                  map { |bm| bm.user }
  end

  def next_list_position
    (lists.maximum(:position) || 0) + 1
  end

  def normalize_list_positions
    lists.each_with_index do |list, index|
      list.update! position: index + 1
    end
  end
end
