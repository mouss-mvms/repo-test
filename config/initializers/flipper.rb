require "flipper/adapters/active_record"
require "flipper/adapters/dalli"

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::ActiveRecord.new
    if Rails.env.local? || Rails.env.test?
      Flipper.new(adapter)
    else
      dalli = Dalli::Client.new(
        ENV["MEMCACHIER_SERVERS"],
        username: ENV["MEMCACHIER_USERNAME"],
        password: ENV["MEMCACHIER_PASSWORD"]
      )
      cached_adapter = Flipper::Adapters::Dalli.new(adapter, dalli, ENV["CACHE_EXPIRATION"])
      Flipper.new(cached_adapter)
    end
  end
end

module Flipper
  def self.enabled?(key)    
    return true if StringHelper.to_bool(ENV['FORCE_FEATURES'])
    super
  end
end