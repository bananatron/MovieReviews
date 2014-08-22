class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end
  
  def profile
    @movies = Movie.find(params[:id])
  end
  
end


