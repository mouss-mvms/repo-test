require "shrine"
require "shrine/storage/s3"

s3_options = {
  bucket: ENV["AWS_BUCKET"],
  region: ENV["AWS_REGION"],
  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
}

old_s3_options = {
  bucket: "e-city",
  region: "eu-central-1",
  access_key_id: "AKIAIDWT2IFATUZXDWCA",
  secret_access_key: "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"
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(public: true, **s3_options),
  old_store: Shrine::Storage::S3.new(**old_s3_options)
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :data_uri
Shrine.plugin :infer_extension, force: true
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :pretty_location
Shrine.plugin :presign_endpoint, presign_options: -> (request) {
                          filename = request.params["filename"]
                          type = request.params["type"]
                          {
                            content_disposition: "inline; filename=\"#{filename}\"",
                            content_type: type,
                            content_length_range: 1..(10*1024*1024),
                          }
                        }
Shrine.plugin :derivatives
Shrine.plugin :model, cache: false
Shrine.plugin :url_options, old_store: -> (io, **) { { public: true } }
Shrine.plugin :add_metadata
Shrine.plugin :default_storage, store: :store
Shrine.plugin :remote_url, max_size: 20*1024*1024
Shrine.plugin :determine_mime_type
