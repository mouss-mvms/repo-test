if Rails.env.local?
  Resque.logger.formatter = Resque::VeryVerboseFormatter.new
end
