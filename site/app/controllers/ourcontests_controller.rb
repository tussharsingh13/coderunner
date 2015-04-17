class OurcontestsController < ApplicationController
 
 def index
 @ourcontests = Ourcontest.all
 @ourcontest = Ourcontest.new
 end

 def new
   #Admin Layer
   if (current_user.admin? == false)
    redirect_to '/404.html' 
   end 
  @ourcontest = Ourcontest.new
 end
 
 def edit
   #Admin Layer
 if (current_user.admin? == false)
    redirect_to '/404.html' 
   end 
  @ourcontest = Ourcontest.find(params[:id])
 end
 
 def create
  @ourcontest=Ourcontest.new(ourcontest_params)
 
  if @ourcontest.save
   redirect_to :action => :index
  else
   render 'ourcontests/new'
  end
 end
 
 def update
  @ourcontest = Ourcontest.find(params[:id])
 
  if @ourcontest.update(ourcontest_params)
    redirect_to @ourcontest
  else
    render 'edit'
  end
 end
 
 def show
  @ourcontest = Ourcontest.find(params[:id])
  @problemedit = Ourproblem.new
 end
 
 def destroy
    @ourcontest = Ourcontest.find(params[:id])
    @ourproblems = Ourproblem.all
    #Before deleting the contest, delete the contest problems through a query
    @contestproblems = @ourproblems.where(:contestid => @ourcontest.id)
    @contestproblems.each do |ourproblem|
     @ourproblem.destroy
     end
     
    #Now,delete the corresponding file in the public folder
    prefix = 'public/problems/problems_list' 
    filename = "#{@ourcontest.id}.txt" 
    fullname = prefix + filename
    if File.exist?(fullname) 
    	File.delete(fullname)
     end 
    @ourcontest.destroy
    
    #Redirect to the Contests Page 
    redirect_to ourcontests_path
 end
 
 private
 def ourcontest_params
    params.require(:ourcontest).permit(:name,:start,:end,:duration)
 end
end
