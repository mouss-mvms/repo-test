require "shrine"
require "shrine/storage/s3"

s3_options = { 
  bucket: ENV["AWS_BUCKET"],
  region: ENV["AWS_REGION"],
  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :pretty_location
Shrine.plugin :presign_endpoint
