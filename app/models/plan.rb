class Plan < ActiveRecord::Base
  include Tokenable

  has_many :users

  validates :name,
    presence: true
  validates :price_per_month,
    presence: true

  def basic?
    price_per_month == 0
  end
end
