class Card < ActiveRecord::Base
  has_many :comments, dependent: :destroy

  belongs_to :list
end
