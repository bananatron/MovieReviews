class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy]
  
  # GET /reviews
  # GET /reviews.json
  def index
    #@reviews = Review.all
    @top_reviews = Review.page(params[:page]).order('score DESC')
    @hot_reviews = Review.where('created_at >= ?', 1.week.ago).paginate(:page => params[:page]).order('score DESC')
    @recent_reviews = Review.page(params[:page]).order('created_at DESC')
    @reviews = @hot_reviews
  end

  def sort
    @sort = params[:sort]
      if @sort == "top"
        @reviews = Review.page(params[:page]).order('score DESC')
      end
      if @sort == "hot"
        @reviews = Review.where('created_at >= ?', 1.week.ago).paginate(:page => params[:page]).order('score DESC')
      end
      if @sort == "recent"
        @reviews = Review.page(params[:page]).order('created_at DESC')
      else
        @reviews = Review.page(params[:page]).order('score DESC')
      end
    render action: :index
  end


  def flag
    @review = Review.find(params[:id])
    if @review.flag == nil
      @review.flag = 1
    else
      @review.flag +=1 
    end
    @review.save
    redirect_to @review, notice: "Summary has been flagged!" 
  end
  
  #Used for upvote and delete_vote
  def calculate_score
    @review.score = @review.votes.count
    @review.save
  end

  def upvote
    @review = Review.find(params[:id])
    @review.votes.create(up:true, user_id:current_user.id)
    calculate_score
    #redirect_to @review
    redirect_to :back
  end
  
  def delete_vote
    @review = Review.find(params[:id])
    #Vote.where(review_id:@review, user_id:current_user.id).destroy_all
    @review.votes.where(user_id:current_user.id).destroy_all
    calculate_score
    redirect_to :back
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])
    @movie = @review.movie
    @score = Vote.where(review_id:(params[:id])).count
  end

  # GET /reviews/new
  def new
    @review = Review.new
    #Passed in for title auto-complete on form
    @movie_names ||= []
    Movie.all.each { |movie| @movie_names << movie.name }
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
    if current_user.id != @review.user_id
      redirect_to @review, notice: "You don't have the authority to do that, man."
    end
  end

  
  # POST /reviews
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.score = 0

    if @review.save
      if @review.movie.moviedb_id == nil
        redirect_to confirm_movie_path(@review.movie)
      else
        redirect_to @review, notice: 'Summary was successfully created.' 
      end
    else 
      redirect_to :back, notice: 'Something is wrong: ' + @review.errors.first.to_s
    end

  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Summary was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  def destroy
    if current_user.id != @review.user_id
      redirect_to @review, notice: "You aren't authorized to do that, man."
    else 
      @review.destroy
      redirect_to reviews_path, notice: "Summary removed!"
    end 
    #If no other reviews for movie & it's a useless entry (without api id), destroy it
    @recent_movie = Movie.where(id:@review.movie_id).last
    @reviews_remaining = Review.where(movie_id:@review.movie_id).count
    if @reviews_remaining == 0 && @recent_movie.moviedb_id == nil
      @recent_movie.destroy
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:movie_title, :movie_id, :rating, :score, :summary)
    end
end
