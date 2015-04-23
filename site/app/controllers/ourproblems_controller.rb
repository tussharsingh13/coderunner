class OurproblemsController < ApplicationController
 def new
 #Admin Layer
 if (current_user.admin? == false)
    redirect_to '/404.html' 
   end 
  @id = params[:ourcontest_id]
  #render :text => "Hey #{@id}"
  @ourcontest=Ourcontest.find(params[:ourcontest_id])
  @ourproblem = Ourproblem.new
 end
 
 def index
 @ourcontest = Ourcontest.find(params[:ourcontest_id])
 end

 def create
  @ourcontest=Ourcontest.find(params[:ourcontest_id])
  @ourproblem = Ourproblem.new(ourproblem_params)
  @ourproblem.contestid = params[:ourcontest_id]
  
  if @ourproblem.save
   	#Retrieve the saved problem to get its id
	@problemretrieve = Ourproblem.find_by! name: @ourproblem.name 
	
	#Save the problem name to the corresponding contest file
	prefix = 'public/problems/problems_list' 
	filename = "#{params[:ourcontest_id]}.txt" 
	fullname = prefix + filename
		if File.exist?(fullname)
		 problems_file = File.open(fullname, "a+") 
		 problems_file.puts(@problemretrieve.id) 
		 problems_file.close  	 
		else
		 problems_file = File.new(fullname, "w+") 
		 problems_file.puts(@problemretrieve.id) 
		 problems_file.close
		end  
        #Open the list of problems
        url = edit_ourcontest_ourproblem_path(@ourcontest,@problemretrieve)
        redirect_to url 
  else
   	render 'new'
  end
 end
  
 def edit
 #Admin Layer
 if (current_user.admin? == false)
    redirect_to '/404.html' 
   end 
 @ourproblem = Ourproblem.find(params[:id])
 end
 
 def update
  @ourproblem = Ourproblem.find(params[:id])
  if @ourproblem.update(ourproblem_params)
	redirect_to ourcontest_ourproblem_path(@ourproblem.contestid,@ourproblem.id)
  else
 	render 'edit'
  end
 end
 
 def show
  @ourcontest = Ourcontest.find(params[:ourcontest_id])
  # Evaluating Conditions 
  	current = Time.zone.now   
	contestBegin = @ourcontest.start   
	contestEnd = @ourcontest.end  
	contestStarted = contestBegin <= current 
	contestNotOver = contestEnd >= current 
	if (!contestStarted || !contestNotOver)
		flash[:notice] = "Contest hasn't started yet!"
		redirect_to welcome_main_path
	end
	
  @ourproblem = Ourproblem.find(params[:id])
 end
 
 def ourproblem_params
    params.require(:ourproblem).permit(:name,:statement,:timelimit,:memory,:code)
  end
end
