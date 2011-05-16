class SessionsController < ApplicationController
  skip_before_filter :require_user
  before_filter :logged_in?, :only => [:new]
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      # user.online
      user.update_attributes(:online => true)
      redirect_to root_path, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    # user.offline
    user.update_attributes(:online => false)
    redirect_to login_path, :notice => "Logged out!"
  end

  private

  def logged_in?
    redirect_to root_path if current_user
  end
end
