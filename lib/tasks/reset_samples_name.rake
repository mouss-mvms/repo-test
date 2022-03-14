namespace :samples do
  namespace :names do
    desc "Reset Samples' name"
    task :reset, [:ids] => :environment do |t, args|
      samples = (args[:ids].nil? || args[:ids].empty?) ? ::Sample.all : ::Sample.where(id: args[:ids])
      samples.each do |sample|
        next if sample.nil?
        reset_sample_name(sample)
      end
    end
  end
end

def reset_sample_name(sample)
  puts "*** Reset Sample Name ***"
  puts "sample : id : #{sample.id}, name: #{sample.name}, product_id: #{sample.product&.id}"
  reference_with_color = sample.references.find { |reference| !reference.color.nil? }
  unless reference_with_color.nil?
    color_name = reference_with_color.color.name
    puts "color_name : #{color_name}"
    unless sample.name == color_name
      sample.update(name: color_name)
      puts "Name updated"
    else
      puts "not need to update"
    end
  else
    puts "No color for sample's references"
  end
  puts "*" * 20
end
