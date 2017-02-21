class Service < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :provider
  validates_presence_of :remote_id
  validates_presence_of :token
  validates_presence_of :user
end
