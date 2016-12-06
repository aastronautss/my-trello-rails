class Plan < ActiveRecord::Base
  include Tokenable

  has_many :users

  validates :name,
    presence: true
  validates :price_per_month,
    presence: true
end
