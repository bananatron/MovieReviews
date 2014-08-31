class MoviesController < ApplicationController
    
  def create_core(title)
    core = title.downcase.split
    bad_words = ["the", "a", "in", "of", "mrs.", "mr.", "ms.", "its", "it's", "it is", "your", 
     "you're", "alot", "then", "than", "to", "too"]
    bad_characters = [":", ",", "'", "!", "~", "#", "+", "&", "`", ";", "$", "%", "(", ")"]

    core.each { |w| w.sub!("-", " ")}
    core.each do |word|
  
      bad_words.each do |bad_word|
        if word == bad_word
          core.delete(word)
        end
      end
    
      bad_characters.each do |bad_character|
        if word.include?bad_character
          word.slice!bad_character
        end
      end
    end
   core = core.join(" ")
   return core
  end

  def find_movie_tmdb(query)
    q = Tmdb::Movie.search(query)
    return q
  end
  
  def index
    @movies = Movie.all
  end
  
  def confirm
    @movie = Movie.find(params[:id])
    #Don't call api results unless you need to.
    if @movie.moviedb_id != nil
      redirect_to movie_path(@movie), notice: 'Movie already has ID.'
    end
    @results ||= find_movie_tmdb(create_core(@movie.name))
  end
  
  def confirm_dbid
    @movie = Movie.find(params[:id])
    @review = Review.where(user_id:current_user.id, movie_id:params[:id]).last
    movie_from_api = Tmdb::Movie.detail params[:moviedb_id]
    
    #Only allow api id assignment if it doesn't have one already
    if @movie.moviedb_id == nil 
      @movie.update_attributes(name: movie_from_api.title, moviedb_id: movie_from_api.id, image: movie_from_api.poster_path, year: movie_from_api.release_date)
      if @review != nil
        #If @review is != nil in, it likely means theyre coming from a review they made
        redirect_to review_path(@review), notice: 'Movie was successfully renamed.'
      else 
        #IF @review is nil, it means they're coming from elsewhere, probably a correction link
        redirect_to movie_path(@movie), notice: 'Movie was successfully renamed.' 
      end
    else 
      redirect_to movie_path(@movie), notice: 'Movie already has ID.' 
    end
  end
  
  def profile
    @movie = Movie.find(params[:id])
  end
  
end

