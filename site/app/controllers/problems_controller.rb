#Controller for Problems

class ProblemsController < ApplicationController

 def new
 end

 def create
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
 
 def problem_params
    params.require(:problemtoedit).permit(:name,:statement,:timelimit,:memory)
  end

end
