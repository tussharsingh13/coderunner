AWS.config(
  :access_key_id => Rails.application.secrets.AWS_ACCESS_KEY_ID,
  :secret_access_key => Rails.application.secrets.AWS_SECRET_ACCESS_KEY,
  :region => Rails.application.secrets.AWS_REGION
)

S3_BUCKET =  AWS::S3.new.buckets[Rails.application.secrets.S3_BUCKET]
