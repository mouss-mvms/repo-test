class ProductCreationJob < ApplicationJob
  queue_as :default

  def perform(**args)
    puts "It's working locally !"
  end
end