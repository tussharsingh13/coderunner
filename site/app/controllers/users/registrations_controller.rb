class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
   def create
    super
   # Make an object in your bucket for your upload
    s3 = AWS::S3.new
    bucket = s3.buckets[Rails.application.secrets.S3_BUCKET_RESPONSES]
    filename = @user.username.to_s+'_'+'response.html'
    path = "public/submissions/"+filename
    uploadfile = File.open(path, "w+")
    	  
    obj = bucket.objects[filename]
    #obj = S3_BUCKET_DETAILS.objects[params[:file].original_filename]
    
   #Upload the file
    obj.write( 
      file: uploadfile,
      acl: :public_read
    )
    File.delete(path)
   end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
