class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :update, :destroy]
  
  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  def upvote
    @review = Review.find(params[:id])
    @review.votes.create(up:true, user_id:current_user.id)
    redirect_to :back
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])
    #redirect_to :back
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    @review = Review.find(params[:id])
  end

  #OLD //Creates movie if no movie matching name is found
  def create_movie(name)
    Movie.create(name: name)
  end
  
  #OLD //Finds if the movie exists and ties the movie_id to the new review on 'create' method
  #If movie doesn't exist by exact name, it creates movie with that name & assigns movie_id.
  #ENH(Need to factor 'the')
  def get_movie_name
    review_name = @review.movie
    mq = Movie.where(name: review_name)
    if mq.first != nil
      mid = mq.first.id
      return mid
    else
      nm = create_movie(review_name)
      @review.movie_id = nm.id
    end
  end
  
 
  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.score = 1

    if @review.save
      redirect_to @review, notice: 'Review was successfully created.' 
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
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
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
