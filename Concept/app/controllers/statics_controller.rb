class StaticsController < ApplicationController
  skip_before_action :require_login, only: [:index]
  before_action :not_logged, only: [:index]
  def index
  end
end
