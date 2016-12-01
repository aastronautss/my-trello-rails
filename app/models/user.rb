class User < ActiveRecord::Base
  attr_accessor :remember_token

  has_many :board_memberships
  has_many :boards, through: :board_memberships

  validates :username, presence: true,
                       length: { minimum: 2, maximum: 25 }
  validates_uniqueness_of :username, case_sensitive: false
  validates :password, length: { minimum: 5 }

  # ====---------------------------====
  # Authentication and Passwords
  # ====---------------------------====

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  # ====---------------------------====
  # Board Membership
  # ====---------------------------====

  def member_of?(board)
    board.members.include? self
  end

  def admin_of?(board)
    board.admins.include? self
  end

  def owner_of?(board) # TODO
  end
end
