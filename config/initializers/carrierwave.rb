if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV["AWS_S3_KEY_ID"],
      :aws_secret_access_key  => ENV["AWS_S3_SECRET_KEY"],
      :path_style             => true
    }
    config.asset_host     = ENV["CDN_HOST"]
    config.fog_directory  = ENV["AWS_S3_BUCKET"]                    # required
    #config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
