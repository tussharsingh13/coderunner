class OurcontestsController < ApplicationController
 
 def index
 @ourcontests = Ourcontest.all
 @ourcontest = Ourcontest.new
 @ourproblems = Ourproblem.all
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
   #Upload COntest metadata to s3
   filename = @ourcontest.code + '#metadata.txt'
	  path = "public/metadata/"+filename
  	  content = @ourcontest.start.to_s + "\n" + @ourcontest.end.to_s
  	  metadatafile = File.open(path, "w+") do |f|
  	  f.write(content)
	  end
  # Make an object in your bucket for your upload
    	   s3 = AWS::S3.new
    	   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_DETAILS]
   	   obj = bucket.objects[filename]
         metadata = File.open(path)
	 #Upload the file to s3 Bucket coderunnersubmissions
	  obj.write( 
	  file: metadata,
	  acl: :public_read
	  )
	 File.delete(path)
	  
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
     	ourproblem.destroy
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
 
 def submit
    @ourcontest = Ourcontest.find(params[:ourcontest_id])
    #Check if contest has started
    current = Time.zone.now   
	contestBegin = @ourcontest.start   
	contestEnd = @ourcontest.end  
	contestStarted = contestBegin <= current 
	contestNotOver = contestEnd >= current 
	if (!contestStarted || !contestNotOver)
		flash[:notice] = "Contest hasn't started yet!"
		redirect_to welcome_main_path
	end
    @ourproblem = Ourproblem.new
    @ourproblems = Ourproblem.all
    #Before deleting the contest, delete the contest problems through a query
    @contestproblems = @ourproblems.where(:contestid => @ourcontest.id)
 end
 
 def verdict
 
 if ((current_user.lastsubmit &&  Time.zone.now.to_s >= (current_user.lastsubmit+2.minutes).to_s) || !current_user.lastsubmit)
  
  #Update last submit
   current_user.update_attribute(:lastsubmit, Time.zone.now)
   
  #Delete response if present
  useresponse = current_user.username + '_response.html'
  s3 = AWS::S3.new
  if (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_USERS].objects[useresponse].exists?)
   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_USERS]
   object = bucket.objects[useresponse]
   object.delete
  end
  #Fetch the contest details
   @ourcontest = Ourcontest.find(params[:ourcontest_id])
  
  #Upload the user submission to cloud	
	#In case no problem is selected
	if params[:value] == ''
	 flash[:notice] = "Please select a problem!"
	 redirect_to :back
	 
	else
	#In case of file upload
	if params[:file]
	@ourproblem = Ourproblem.find_by code: params[:value]
	#Compose the filename
	#Standard -> Usercode#ContestCode#ProblemCode#Timestamp#Timelimit#MemoryLimit#
	  filename = current_user.username+'#'+@ourcontest.code+'#'+@ourproblem.code+'#'+Time.zone.now.to_s+'#'+@ourproblem.timelimit.to_i.to_s+'#'+@ourproblem.memory.to_s+'#.cpp'

	 # Make an object in your bucket for your upload
    	   s3 = AWS::S3.new
    	   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_SUBMISSIONS]
   	   obj = bucket.objects[filename]
    	   #obj = S3_BUCKET_DETAILS.objects[params[:file].original_filename]
        
	 #Upload the file to s3 Bucket coderunnersubmissions
	  obj.write( 
	  file: params[:file],
	  acl: :public_read
	  )

	#In case of editor
	elsif params[:code]
	@ourproblem = Ourproblem.find_by code: params[:value]
	
	#Compose the filename
	#Standard -> Usercode#ContestCode#ProblemCode#Timestamp#Timelimit#MemoryLimit#
	  filename = current_user.username+'#'+@ourcontest.code+'#'+@ourproblem.code+'#'+Time.zone.now.to_s+'#'+@ourproblem.timelimit.to_i.to_s+'#'+@ourproblem.memory.to_s+'#.cpp'
	  path = "public/submissions/"+filename
  	  content = params[:code]
  	  File.open(path, "w+") do |f|
  	  f.write(content)
	  end

  	  # Make an object in your bucket for your upload
    	   s3 = AWS::S3.new
    	   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_SUBMISSIONS]
   	   obj = bucket.objects[filename]
    	   #obj = S3_BUCKET_DETAILS.objects[params[:file].original_filename]
        
	#Upload the file to s3 Bucket coderunnersubmissions
	 uploadfile = File.open(path)
	 obj.write( 
	 file: uploadfile,
	 acl: :public_read
	 )
  	 uploadfile.close

  	 File.delete(path)
	end #end inner if
	
   useresponse = current_user.username + '_response.html'
   @finalresponse = '/responses/'+useresponse
   flag = 0 
   #until (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_USERS].objects[useresponse].exists?) do
   for i in 0..30
    if (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_USERS].objects[useresponse].exists?)
    	flag = 1
    	break
    end
    sleep 1
   end
   
   if flag == 0
     render :text => "Server Error, check My Submissions after a while"
     return false
   end
   
 s3 = AWS::S3.new
  bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_USERS]
  object = bucket.objects[useresponse]
  File.open('public/responses/'+useresponse, "w+") do |file|
    object.read do |chunk|
      file.write(chunk)
    end
   end
  #Delete the reponse from the bucket
  #object.delete
  end #outer if
  else
   render :text => "The gap between two submissions must be atleast 2 minutes"
   #render :text => current_user.lastsubmit
  end
 end
 
 def ranking
  @ourcontest = Ourcontest.find(params[:ourcontest_id])
  ranklist = @ourcontest.code + '_ranking.html'
  @currentranklist = '/ranking/'+ranklist
  
  flag = 0 
   #until (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_DETAILS].objects[ranklist].exists?) do
   for i in 0..15
    if (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_DETAILS].objects[ranklist].exists?)
    	flag = 1
    	break
    end
    sleep 1
   end
   
   if flag == 0
     render :text => "Server Error, reload Ranklist after a while"
     return false
   end
   
  s3 = AWS::S3.new
  bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_DETAILS]
  object = bucket.objects[ranklist]
  File.open('public/ranking/'+ranklist, "w+") do |file|
    object.read do |chunk|
      file.write(chunk)
    end
   end
  File.delete('public/ranking/'+ranklist)
 end

 def submissions
  useresponse = current_user.username + '_response.html'
  @finalresponse = '/responses/'+useresponse
  for i in 0..15
    if (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_RESPONSES].objects[useresponse].exists?)
    	flag = 1
    	break
    end
    sleep 1
   end
   
   if flag == 0
     render :text => "Server Error, reload Submissions after a while"
     return false
   end
   
  s3 = AWS::S3.new
  bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_RESPONSES]
  object = bucket.objects[useresponse]
  File.open('public/responses/'+useresponse, "w+") do |file|
    object.read do |chunk|
      file.write(chunk)
    end
   end
 
 end
 
 private
 def ourcontest_params
    params.require(:ourcontest).permit(:name,:start,:end,:duration,:code)
 end
 
end
