environment = ENV['RAILS_ENV'] || ENV['RACK_ENV']

Refile.configure do |config|

  max_size = Integer(ENV['MAX_ATTACHMENT_SIZE'] || 10485760) # 10 megabytes

  if environment == 'test'
    config.cache = Refile::Backend::FileSystem.new('tmp/refile/cache', max_size: max_size)
    config.store = Refile::Backend::FileSystem.new('tmp/refile/store', max_size: max_size)
  else
    aws = {
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY'],
      bucket: ENV['AWS_S3_BUCKET'] || "jobmensa2-#{environment}",
      region: ENV['AWS_S3_REGION'] || 'eu-west-1',
      max_size: max_size
    }

    config.cache = Refile::Backend::S3.new(prefix: 'cache', **aws)
    config.store = Refile::Backend::S3.new(prefix: 'store', **aws)
  end

  # Secretkey for signing urls
  config.secret_key = ENV['REFILE_SECRET_KEY']

  # Configure the request origin
  config.allow_origin = '*'

  # Do not mount as refile_app for rails
  config.automount = false

  unless environment == 'test' # go to the app server
    host = ENV['REFILE_HOST'] || ENV['HOST_NAME']
    # cloudfront or our server
    config.host = "//#{host}"
  end

  # Delete default processors and use our own processors defined below
  config.instance_variable_set :@processors, nil
end

[:default, :convert, :limit, :fit, :fill, :pad, ].each do |name|
  Refile.processor(name, JobmensaAssets::ImageProcessor.new(name))
end

[:image, :attachment].each do |type|
  Refile.types[type] = Refile::Type.new(type)
  Refile.types[type].content_type = JobmensaAssets::AttachmentType.content_type(Refile.types[type])
end