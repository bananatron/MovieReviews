class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  has_many :votes
  
  validates_presence_of :movie, :summary, :user_id
  validates_uniqueness_of :summary
  
  def movie=(title)
    self[:movie_id] = Movie.where(name: title).first.id
  end
end
