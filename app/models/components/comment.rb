class Comment < ActiveRecord::Base
  belongs_to :card
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :card_id, presence: true
  validates :user_id, presence: true
  validates_presence_of :body
end
