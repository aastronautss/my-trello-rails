class Board < ActiveRecord::Base
  has_many :lists, dependent: :destroy
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
end
