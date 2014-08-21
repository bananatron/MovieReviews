class AddMoviesTable < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.integer :moviedb_id
    end
  end
end
