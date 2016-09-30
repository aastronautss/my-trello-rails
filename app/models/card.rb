class Card < ActiveRecord::Base
  ACTIVITY_TYPES = [:log, :comment]

  has_many :comments, dependent: :destroy
  belongs_to :list

  validates_presence_of :title
  validates_presence_of :list

  serialize :activities, HashSerializer

  delegate :board_members, to: :list

  def add_activity(text, user, type: :log)
    raise ArgumentError unless ACTIVITY_TYPES.include? type

    activity_obj = {
      text: text,
      type: type,
      timestamp: Time.now.to_s,
      user: {
        username: user.username,
        id: user.to_param
      }
    }

    self.activities[:items] ||= []
    self.activities[:items] << activity_obj
    self.save
  end
end
