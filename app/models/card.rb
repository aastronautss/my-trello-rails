class Card < ActiveRecord::Base
  ACTIVITY_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'activity.json_schema').to_s
  CHECKLIST_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'checklist.json_schema').to_s

  belongs_to :list

  validates_presence_of :title
  validates_presence_of :list
  validates :activities, json: { schema: ACTIVITY_JSON_SCHEMA }
  validates :checklists, json: { schema: CHECKLIST_JSON_SCHEMA }

  serialize :activities, HashSerializer
  serialize :checklists, HashSerializer

  delegate :board_members, to: :list

  def update(params, user)
    if super(params)
      previous_changes.except('updated_at').each_key do |attribute|
        self.add_activity("edited #{attribute}", user)
      end

      self
    else
      false
    end
  end

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

  # ====------------------------------====
  # Checklists
  # ====------------------------------====

  def add_checklist(title, user)
    checklist_obj = {
      title: title,
      check_items: []
    }

    self.checklists[:lists] ||= []
    self.checklists[:lists] << checklist_obj
    self.valid? ? self.add_activity("added checklist '#{title}'", user) : false
  end

  def add_check_item(name, checklist_idx)
    check_item_obj = {
      name: name,
      done: false
    }

    list = self.checklists[:lists][checklist_idx]
    list[:check_items] << check_item_obj
    self.save
  end
end
