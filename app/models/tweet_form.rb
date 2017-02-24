class TweetForm
  attr_accessor :status

  include ActiveModel::Model

  validates_presence_of :status
end
