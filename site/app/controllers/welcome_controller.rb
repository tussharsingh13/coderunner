class WelcomeController < ApplicationController
  def index
  end

  def main
  @ourcontests = Ourcontest.all
  end
  
end
