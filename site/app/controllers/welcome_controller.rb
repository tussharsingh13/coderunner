class WelcomeController < ApplicationController
  def index
  end

  def main
  @ourcontests = Ourcontest.all
  @ourproblems = Ourproblem.all
  end
  
end
