class QueuesController < ApplicationController
  def add
    @song = Song.find(params[:id])
    @song.enqueue!(User.first)
    redirect_to root_path
  end
end
