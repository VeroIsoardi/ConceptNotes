class ApplicationController < ActionController::Base
  before_action :require_login
  private
  def not_authenticated
    redirect_to :home
  end


  private
  def not_logged
    if  logged_in?
      flash[:error] = "Uh oh wrong page!"
      redirect_to :root
    end
  end
end
