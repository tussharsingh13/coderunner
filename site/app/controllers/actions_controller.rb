class ActionsController < ApplicationController
 #File Upload
  def uploadfile
  end
  
  def savefile
    post = Datafile.save(params[:user_record])
    render :text => "File has been uploaded successfully"
  end
 #Integration of Editor
 def editor
  @solution = Solution.new
 end
 
 def submitcode
  @solution = Solution.new(solution_params)
  path = "public/submissions/code1.txt"
  content = @solution.code
  File.open(path, "w+") do |f|
  f.write(content)
  end
 end
 
 def instructionmanual
 end
 
 #Testing aws
 def uploadtoaws
 end
 
 def uploadedtoaws
 #Function to upload test data to the s3 bucket
 
 # Make an object in your bucket for your upload
    s3 = AWS::S3.new
    bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_DETAILS]
    filename = params[:file].original_filename
    obj = bucket.objects[filename]
    #obj = S3_BUCKET_DETAILS.objects[params[:file].original_filename]
    
 #Upload the file
    obj.write( 
      file: params[:file],
      acl: :public_read
    )
    flash[:notice] = 'TEST CASES UPLOADED'
    redirect_to :back  
  end
 
  def requestsent
   @user = User.find_by username: params[:username]
   UserMailer.send_admin_email(@user).deliver_now
   flash[:notice] = "Request Sent to Admin. Wait for Approval!"
   redirect_to '/welcome/main'  
  end
  
  def requestapproved
   @user = User.find_by username: params[:username]
   @user.update_attribute(:admin, true)
    flash[:notice] = "#{@user.username} added as Admin!"
   redirect_to '/welcome/main'  
  end
  
  def staticcodequalitycheck
  end
  
  def staticcodequalityresponse
  #Delete response if present
  useresponse = current_user.username + '_response.html'
  s3 = AWS::S3.new
  if (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_STATICCODERESPONSES].objects[useresponse].exists?)
   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_STATICCODERESPONSES]
   object = bucket.objects[useresponse]
   object.delete
  end
  
  #In case of file upload
	if params[:sourcefile]
	
	#Compose the filename
	#Standard -> username#timestamp#.cpp
	  filename = current_user.username+'#'+Time.zone.now.to_s+'#.cpp'
	
	# Make an object in your bucket for your upload
    	   s3 = AWS::S3.new
    	   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_STATICCODEQUALITY]
   	   obj = bucket.objects[filename]
    	   #obj = S3_BUCKET_DETAILS.objects[params[:file].original_filename]
        
	 #Upload the file to s3 Bucket coderunnersubmissions
	  obj.write( 
	  file: params[:sourcefile],
	  acl: :public_read
	  )
	
	#In case of editor
	elsif params[:sourcecode]
	
	#Compose the filename
	#Standard -> username#timestamp#.cpp
	  filename = current_user.username+'#'+Time.zone.now.to_s+'#.cpp'
	  path = "public/submissions/"+filename
  	  content = params[:sourcecode]
  	  File.open(path, "w+") do |f|
  	  f.write(content)
	  end

  	  # Make an object in your bucket for your upload
    	   s3 = AWS::S3.new
    	   bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_STATICCODEQUALITY]
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
  	 
  	 useresponse = current_user.username + '_response.html'
	   @finalresponse = '/qualityresponses/'+useresponse
	   flag = 0 
	  
   	 for i in 0..30
        	if (AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET_STATICCODERESPONSES].objects[useresponse].exists?)
    		 flag = 1
    		break
    	 	end
    	 sleep 1
   	 end
   
  	 if flag == 0
  	   render :text => "Server Error, try again after sometime"
     	   return false
   	 end
   
 	s3 = AWS::S3.new
  	bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_STATICCODERESPONSES]
  	object = bucket.objects[useresponse]
  	File.open('public/qualityresponses/'+useresponse, "w+") do |file|
    	object.read do |chunk|
      	file.write(chunk)
    	  end
  	end
  
   end

  end
  
  private 
  def solution_params
    params.require(:solution).permit(:problem,:code)
  end
  
  
end

