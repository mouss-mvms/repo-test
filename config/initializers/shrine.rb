require "shrine"
require "shrine/storage/s3"
require "shrine/storage/memory"

if Rails.env.test?
  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new,
  }
else
  old_s3_options = {
    bucket: "e-city",
    region: "eu-central-1",
    access_key_id: "AKIAIDWT2IFATUZXDWCA",
    secret_access_key: "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"
  }

  s3_options = {
    bucket: ENV["AWS_BUCKET"],
    region: ENV["AWS_REGION"],
    access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  }
  Shrine.storages = {
    old_store: Shrine::Storage::S3.new(**old_s3_options),
    store: Shrine::Storage::S3.new(public: true, **s3_options)
  }
end

Shrine.plugin :activerecord
Shrine.plugin :validation_helpers
Shrine.plugin :pretty_location
Shrine.plugin :derivatives
Shrine.plugin :model, cache: false
Shrine.plugin :add_metadata
Shrine.plugin :default_storage, store: :store
Shrine.plugin :url_options, old_store: -> (io, **) { { public: true } }
Shrine.plugin :remote_url, max_size: 20*1024*1024
Shrine.plugin :determine_mime_type
