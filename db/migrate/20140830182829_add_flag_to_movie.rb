class AddFlagToMovie < ActiveRecord::Migration
  def change
    remove_column :reviews, :rating
    add_column :reviews, :flag, :integer
    add_column :movies, :flag, :integer
    add_column :movies, :year, :integer
    add_column :movies, :image, :string
    add_column :users, :flag, :integer
  end
end
