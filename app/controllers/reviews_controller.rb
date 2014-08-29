class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy]
  
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
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
    redirect_to @review
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
    @score = Vote.where(review_id:(params[:id])).count
  end

  # GET /reviews/new
  def new
    @review = Review.new
    #Passed in for title auto-complete in form #change to conditional set?
    @movie_names = []
    Movie.all.each { |movie| @movie_names << movie.name }
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
    if current_user.id != @review.user_id
      redirect_to @review, notice: "You don't have authorization"
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
        redirect_to @review, notice: 'Review was successfully created.' 
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
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    if current_user.id != @review.user_id
      redirect_to :back, notice: "You aren't authorized."
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
