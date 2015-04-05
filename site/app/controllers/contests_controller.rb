#Controller for Contests
class ContestsController < ApplicationController
#Two class variables for one contest session
@@contestexists = 0
@@contestretrieve = Contest.new

  def index
  end
  
  def new
  @@contestexists = 0
  @@contestretrieve = Contest.new
  end

  def contestadded
   if @@contestexists == 0
	#render plain: params[:contest].inspect
	@contest=Contest.new(contest_params)

	#Save the contest
	@contest.save

	#Retrieve the contest id so that it can be used in the view
	@@contestretrieve = Contest.find_by! name: @contest.name
	
	#Contest has been added
	@@contestexists += 1	
  
   else
	#Save the problem to the database
	@problem = Problem.new(problem_params)
	
	#render plain: params[:problem].inspect
	@problem.save!
	
	#Retrieve the saved problem to get its id
	@problemretrieve = Problem.find_by! name: @problem.name 
	
	#Save the problem name to the corresponding contest file
	prefix = 'public/problems/problems_list' 
	filename = "#{@@contestretrieve.id}.txt" 
	fullname = prefix + filename
	if File.exist?(fullname)
	 problems_file = File.open(fullname, "w+") 
	 problems_file.write(@problemretrieve.name) 
	 problems_file.close  	 
	else
	 problems_file = File.new(fullname, "w") 
	 problems_file.write(@problemretrieve.name) 
	 problems_file.close  
  end
   end
  end
  
  def show
  end
  
  def update
  end
  helper_method :contestexists, :contestretrieve
  
  #For accessing class variables inside views
  def contestexists
   @@contestexists
  end
  
  def contestretrieve
   @@contestretrieve
  end
	
  def problem_params
    params.require(:problem).permit(:name,:statement,:timelimit,:memory)
  end

  def contest_params
    params.require(:contest).permit(:name,:dateandtime,:duration)
  end
  

end
