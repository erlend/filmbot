class RafflesController < ApplicationController

  def show
    @card = current_user.random_movie
    redirect_to config_path unless @card
  end

  def equal
    @card = current_user.random_movie(false)
    render :show
  end

end
