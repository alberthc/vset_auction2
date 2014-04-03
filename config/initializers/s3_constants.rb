# config/initializers/s3_constants.rb

if !Rails.env.production?
  S3_BUCKET_NAME = "vsetauction"
  AWS_ACCESS_KEY_ID = "AKIAJRQ4TBVSZMGIGRKA"
  AWS_SECRET_ACCESS_KEY = "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"
end
