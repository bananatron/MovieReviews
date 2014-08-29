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
    Tmdb::Api.key("a2038ba65a6e1cffb5e59cee83bd1bcd")
    q = Tmdb::Movie.search(query)
    return q
  end
  
  def index
    @movies = Movie.all
  end
  
  def confirm
    @movies = Movie.find(params[:id])
    @results = find_movie_tmdb(create_core(@movies.name))
  end
  
  def confirm_dbid
    @movies = Movie.find(params[:id])
    if @movies.moviedb_id == nil
      @movies.moviedb_id = params[:moviedb_id]
      @movies.name = params[:name]
      @movies.save
      @review = Review.where(user_id:current_user.id, movie_id:params[:id]).last
      redirect_to review_path(@review), notice: 'Movie was successfully renamed.' 
    else 
       @review = Review.where(user_id:current_user.id, movie_id:params[:id]).last
      redirect_to review_path(@review), notice: 'Movie already has ID.' 
    end
  end
  
  def profile
    @movies = Movie.find(params[:id])
  end
  
end

