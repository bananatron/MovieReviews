class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  has_many :votes
  
  validates_presence_of :movie, :summary, :user_id
  validates_uniqueness_of :summary
  
  def movie=(title)
    if movie = Movie.where(name: title).first
      self[:movie_id] = movie.id
    else
      m = Movie.create(:name => title)
      self[:movie_id] = m.id
    end
  end
end
