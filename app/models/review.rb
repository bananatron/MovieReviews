class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  has_many :votes
  
  validates_presence_of :summary, :user_id
  validates_uniqueness_of :summary
  validates_length_of :summary, maximum: 140
  validates_length_of :movie_title, maximum: 70
  
  def movie_title
    movie.name.downcase if movie
  end

  #Does case insenstive search for movies matching same title and assigns them to review
  #Need to fix this where movie is being created even if save isn't complete on review
  def movie_title=(title)
     mt = Movie.arel_table
    m = Movie.where(mt[:name].matches(title)).first
    if movie = m
      self[:movie_id] = movie.id
    else 
      m = Movie.create(name: title)
      self[:movie_id] = m.id
    end
  end
end
