class Card < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :list

  validates_presence_of :title
  validates_presence_of :list
end
