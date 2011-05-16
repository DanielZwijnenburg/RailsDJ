class SetupsController < ApplicationController
  skip_before_filter :check_setup
  skip_before_filter :require_user

  layout "setup"

  def index
  end

  def show
    @setup = Setup.find(params[:id])
    @results = Library.fs_songs
  end

  def new
    @setup = Setup.first
  end

  def create
    @setup = Setup.new(params[:setup])
    if @setup.save
      redirect_to @setup
    else
      render :action => :new
    end
  end

  def update
    @setup = Setup.find(params[:id])
    if @setup.update_attributes(params[:setup])
      redirect_to @setup
    else
      render :action => :new
    end
  end

  def completed
    @setup = Setup.find(params[:id])
    if Library.fs_songs.count > 0
      @setup.update_attributes(:setup_completed => 1)
      Library.import_songs
      redirect_to root_path, :notice => "Setup completed"
    else
      redirect_to setups_path
    end
  end
end