class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  has_many :votes
  
  validates_presence_of :movie, :summary, :user_id
  validates_uniqueness_of :summary
  validates_length_of :summary, maximum: 140
  
  def movie_title
    movie.name if movie
  end

  def movie_title=(title)
    if movie = Movie.where(name: title).first
      self[:movie_id] = movie.id
    else 
      Movie.create(name: title)
    end
  end
end
