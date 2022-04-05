require "flipper/adapters/active_record"

unless Rails.env.test?
  require "flipper/adapters/dalli"

  Flipper.configure do |config|
    config.default do
      adapter = Flipper::Adapters::ActiveRecord.new
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