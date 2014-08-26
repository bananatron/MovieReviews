class RemoveMovieFromReview < ActiveRecord::Migration
  def change
    remove_column :reviews, :movie
  end
end
