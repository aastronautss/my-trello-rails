class List < ActiveRecord::Base
  has_many :cards

  belongs_to :board
end
