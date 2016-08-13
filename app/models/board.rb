class Board < ActiveRecord::Base
  has_many :lists, dependent: :destroy
  has_many :board_memberships
  has_many :members, through: :board_memberships, source: :user

  def add_member(user, admin = false, owner = false)
    board_memberships.create user: user, admin: admin, owner: owner
  end

  def remove_member(user)
    board_memberships.find_by(user: user).destroy
  end

  def admins
    @admins ||= board_memberships.where(admin: true).map { |bm| bm.user }
  end
end
