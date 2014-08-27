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
    @score = Vote.where(review_id:(params[:id])).count
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

  # POST /reviews
  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.score = 0
    
    if @review.save
      redirect_to @review, notice: 'Review was successfully created.' 

    else 
      redirect_to :back, notice: 'Something is wrong'
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
