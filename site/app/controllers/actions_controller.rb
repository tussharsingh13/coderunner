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
 # Make an object in your bucket for your upload
    s3 = AWS::S3.new
    bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_DETAILS]
    filename = 'user1/' + params[:file].original_filename
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
  
  private 
  def solution_params
    params.require(:solution).permit(:problem,:code)
  end
  
  
end

