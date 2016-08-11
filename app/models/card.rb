class Card < ActiveRecord::Base
  has_many :comments

  belongs_to :list
end
