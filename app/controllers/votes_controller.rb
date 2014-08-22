class VotesController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @vote = Vote.find(params[:id])
  end

  def create
    @vote = Vote.create(params[:up])
    redirect_to :back
  end
end