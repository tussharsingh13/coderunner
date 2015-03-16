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
 
 #Testing aws
 def uploadtoaws
 end
 
 def uploadedtoaws
 # Make an object in your bucket for your upload
     
    obj = S3_BUCKET.objects[params[:file].original_filename]
	AWS::S3::Bucket.delete('tootoo3')
	#if S3_BUCKET.exists?
	#	render plain: "exists"
	#end
     #Upload the file
    obj.write(
      file: params[:file],
      acl: :public_read
    )
 end
 
  private 
  def solution_params
    params.require(:solution).permit(:problem,:code)
  end
  
  
end

