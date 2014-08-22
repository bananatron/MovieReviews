class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  validates_presence_of :movie, :summary, :user_id
  validates_uniqueness_of :summary
end
