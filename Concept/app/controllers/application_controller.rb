class ApplicationController < ActionController::Base
  before_action :require_login
  private
  def not_authenticated
    redirect_to :home
  end


  private
  def not_logged
    if  logged_in?
      flash[:error] = "Hey! This is not the page you are looking for."
      redirect_to :root
    end
  end
end
