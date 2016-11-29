module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def to_param
    token
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
