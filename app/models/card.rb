class Card < ActiveRecord::Base
  ACTIVITY_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'activity.json_schema').to_s

  has_many :comments, dependent: :destroy
  belongs_to :list

  validates_presence_of :title
  validates_presence_of :list
  validates :activities, json: { schema: ACTIVITY_JSON_SCHEMA }

  serialize :activities, HashSerializer

  delegate :board_members, to: :list

  ##
  # This might be worth doing, but requires an additional parameter
  # passed into the `#update` method.
  ##
  #
  # def update(user, params)
  #   params.each_key do |key|
  #     self.add_activity "edited #{key}", user
  #   end

  #   super params
  # end

  # ====------------------------------====
  # Activity Logging
  # ====------------------------------====

  def add_activity(text, user, type: :log)
    activity_obj = {
      text: text,
      type: type,
      timestamp: Time.now.to_s,
      user: {
        username: user.username,
        id: user.to_param.to_s
      }
    }

    self.activities[:items] ||= []
    self.activities[:items] << activity_obj
    self.save
  end

  def add_comment(text, user)
    add_activity text, user, type: :comment
  end
end
