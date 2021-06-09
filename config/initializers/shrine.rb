require "shrine"
require "shrine/storage/s3"

s3_options = {
  bucket: ENV["AWS_BUCKET"],
  region: ENV["AWS_REGION"],
  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
}

Shrine.storages = {
  store: Shrine::Storage::S3.new(public: true, **s3_options)
}

Shrine.plugin :validation_helpers
Shrine.plugin :pretty_location
Shrine.plugin :derivatives
Shrine.plugin :model, cache: false
Shrine.plugin :add_metadata
Shrine.plugin :default_storage, store: :store
Shrine.plugin :remote_url, max_size: 20*1024*1024
Shrine.plugin :determine_mime_type
