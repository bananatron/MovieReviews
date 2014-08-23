class VotesController < ApplicationController
  before_filter :authenticate_user!

end