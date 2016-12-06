class ActivatedController < ApplicationController
  before_action :require_user
  before_action :require_activated_user
end
