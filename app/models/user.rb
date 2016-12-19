class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_many :board_memberships
  has_many :boards, through: :board_memberships
  has_many :payments
  has_many :card_watchings
  has_many :watched_cards, through: :card_watchings, source: :card

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
    presence: true,
    confirmation: true,
    length: { minimum: 5 },
    on: :create
  validates :password,
    presence: true,
    confirmation: true,
    length: { minimum: 5 },
    allow_blank: true,
    on: :update

  def to_param
    username
  end

  # ====---------------------------====
  # Authentication and Passwords
  # ====---------------------------====

  has_secure_password validations: false

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
    update_attribute :remember_digest, nil
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

  def generate_temporary_password
    pw = User.new_token
    self.password = pw
    self.password_digest = pw
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

  # ====---------------------------====
  # Subscriptions and Plans
  # ====---------------------------====

  def plan_object
    Plan.new plan
  end

  def subscribe_to(plan_name, stripe_token = nil)
    handler = SubscriptionHandler.new(self).subscribe(plan_name, stripe_token)

    if handler.successful?
      self.save
    else
      false
    end
  end

  # ====---------------------------====
  # Watchings
  # ====---------------------------====

  def watch(object)
    return false if watching?(object)
    type = object.class.to_s.tableize
    self.send("watched_#{type}") << object
  end

  def unwatch(object)
    return false unless watching?(object)
    type = object.class.to_s.tableize
    self.send("watched_#{type}").delete object
  end

  def watching?(object)
    type = object.class.to_s.tableize
    self.send("watched_#{type}").include?(object)
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
