class UsersController < ApplicationController

  def show
  end

  def profile

    @user_reviews = User.find(params[:id]).reviews.paginate(:page => params[:page]).order('score DESC')
      @user_id = params[:id].to_i
      @user = User.find(params[:id])
  end
  

end