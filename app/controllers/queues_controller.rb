class QueuesController < ApplicationController
  def add
    @song = Song.find(params[:id])
    @song.enqueue!(current_user)
    redirect_to root_path
  end
end
