RSpec.configure do |config|
  config.before(:suite) do
    keys = YAML::load(File.read(File.join(Rails.root, "config", "flipper_keys.yaml")))["keys"]
    keys&.each do |key|
      adapter = Flipper::Adapters::ActiveRecord.new
      flipper = Flipper.new(adapter)
      flipper.add(key)
      flipper.enable(key)
    end
  end

  config.after(:suite) do
    keys = YAML::load(File.read(File.join(Rails.root, "config", "flipper_keys.yaml")))["keys"]
    keys&.each do |key|
      adapter = Flipper::Adapters::ActiveRecord.new
      flipper = Flipper.new(adapter)
      flipper.remove(key)
    end
  end
end