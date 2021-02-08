class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  skip_before_action :require_login, only: [:new, :create]
  before_action :not_logged, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Profile was successfully updated."
      redirect_to :root
    else
      render :edit, status: :unprocessable_entity 
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end
end