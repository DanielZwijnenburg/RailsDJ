class UsersController < ApplicationController
  skip_before_filter :require_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_path, :notice => "Signed up! now login!"
    else
      render "new", :notice => "Something went wrong!"
    end
  end
end
