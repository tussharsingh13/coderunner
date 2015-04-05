class OurproblemsController < ApplicationController
 def new
  @id = params[:ourcontest_id]
  #render :text => "Hey #{@id}"
  @ourcontest=Ourcontest.find(params[:ourcontest_id])
  @ourproblem = Ourproblem.new
 end
 
 def index
 #@ourproblems = Ourcontest.all
 @ourcontest = Ourcontest.new
 end

 def create
  @ourcontest=Ourcontest.find(params[:ourcontest_id])
  @ourproblem = Ourproblem.new(ourproblem_params)
  @ourproblem.contestid = params[:ourcontest_id]
  
  if @ourproblem.save
  render plain: params[:ourproblem].inspect
  render :text => "hey"
   redirect_to :action => :index
  else
   render 'ourcontests/#{params[:ourcontest_id]}/ourproblems'
  end
 end
  
 def edit
 @problemtoedit = Problem.find(params[:id])
 end
 
 def update
 @problemtoedit = Problem.find(params[:id])
 @problemtoedit.update(problem_params)
 end
 
 def show
 end
 
 def ourproblem_params
    params.require(:ourproblem).permit(:name,:statement,:timelimit,:memory)
  end
end
