CarrierWave.configure do |config|
  config.cache_dir = Rails.root.join('tmp', 'uploads')
  config.root      = Rails.root.join('tmp')

  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Rails.config.aws.token,
    :aws_secret_access_key  => Rails.config.aws.secret,
  }
  config.fog_directory = Rails.config.aws.bucket || "globalguide-#{Rails.env}"
end