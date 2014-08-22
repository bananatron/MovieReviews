class UsersController < ApplicationController

  def show
  end
  
  def profile
    @user_reviews = current_user.reviews
  end
  
end
