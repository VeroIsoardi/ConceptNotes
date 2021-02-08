class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :not_logged, only: [:new, :create]
  def new
    redirect_to(:root) if current_user.present?
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to(:root)
    else
      flash[:error] = 'Login failed'
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = "Logout successful"
    redirect_to :home
  end

  def user
    current_user()
  end
end