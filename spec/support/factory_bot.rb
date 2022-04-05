RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.find_definitions
  end
  config.include FactoryBot::Syntax::Methods
end