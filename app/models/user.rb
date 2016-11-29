class User < ActiveRecord::Base
  has_many :board_memberships
  has_many :boards, through: :board_memberships

  validates :username, presence: true,
                       length: { minimum: 2, maximum: 25 }
  validates_uniqueness_of :username, case_sensitive: false
  validates :password, length: { minimum: 5 }

  has_secure_password

  def member_of?(board)
    board.members.include? self
  end

  def admin_of?(board)
    board.admins.include? self
  end

  def owner_of?(board) # TODO
  end
end
