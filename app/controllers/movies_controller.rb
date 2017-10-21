class MoviesController < ApplicationController

  def index
    @movies = User.instance.pending_movies_cached
  end

end
