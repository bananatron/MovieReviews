class StaticsController < ApplicationController

  def about
  end

  def flagged
    @reviews = Review.where.not(flag:nil)
    @movies = Movie.where.not(flag:nil)
  end
  

end