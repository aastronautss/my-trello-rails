class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :board_memberships
  has_many :boards, through: :board_memberships

  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL },
    uniqueness: { case_sensitive: false }
  validates :username,
    presence: true,
    length: { minimum: 2, maximum: 25 },
    uniqueness: { case_sensitive: false }
  validates :password,
    length: { minimum: 5 }

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
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(self.remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def activate!
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  # ====---------------------------====
  # Password Resets
  # ====---------------------------====

  def create_reset_token
    self.reset_token = User.new_token
    update_attribute :reset_digest, User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  def reset_expired?
    reset_sent_at < 2.hours.ago
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

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
