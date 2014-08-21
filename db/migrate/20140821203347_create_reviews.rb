class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :movie
      t.integer  :rating
      t.integer  :score
      t.string :summary

      t.timestamps
    end
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :avatar
      t.text :description

      t.timestamps
    end
  end
end
