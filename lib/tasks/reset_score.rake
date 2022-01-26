namespace :products do
  namespace :scores do
    desc "Reset Product score"
    task :reset, [:ids] => :environment do |t, args|
      products = (args[:ids].nil? || args[:ids].empty?) ? ::Product.saleable : ::Product.where(id: args[:ids])
      products.each do |product|
        reset_product_score(product)
      end
    end
  end
end

namespace :shops do
  namespace :scores do
    desc "Reset Scores for Shops and Products"
    task :reset, [:ids] => :environment do |t, args|
      shops = (args[:ids].nil? || args[:ids].empty?) ? ::Shop.without_deleted : ::Shop.where(id: args[:ids])
      updated_count = 0
      shops.each do |shop|
        reset_shop_score(shop)
        updated_count += 1
        puts "*** #{updated_count} shops updated on #{shops.count} ***"
      end
    end
  end
end

def reset_shop_score(shop)
  puts "*** Reset Shop Score ***"
  puts "shop: id: #{shop.id}, name: #{shop.name}, old_score: #{shop.score}"
  shop.update(score: -1)
  shop.products.each do |product|
    reset_product_score(product)
  end
  ::Shops::Score.update(shop: shop)
  puts "shop_id: #{shop.id}, name: #{shop.name}, new_score: #{shop.score}"
  puts "*" * 20
end

def reset_product_score(product)
  puts "*** Reset Product Score ***"
  puts "product: id: #{product.id}, name: #{product.name}, old_score: #{product.score}"
  product.update(score: -1)
  ::Products::Score.update(product: product)
  puts "product_id: #{product.id}, name: #{product.name}, new_score: #{product.score}"
  puts "*" * 20
end