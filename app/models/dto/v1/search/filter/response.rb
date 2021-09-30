module Dto
  module V1
    module Search
      module Filter
        class Response
          attr_accessor :base_price, :colors, :sizes, :services, :categories, :brands

          def initialize(**args)
            @base_price = args[:base_price]
            @colors = args[:colors]
            @sizes = args[:sizes]
            @services = args[:services]
            @categories = args[:categories]
            @brands = args[:brands]
          end

          def self.create(aggs)
            filters = set_filters(aggs)
            self.new(**filters)
          end

          def to_h
            {
              basePrice: @base_price,
              colors: @colors,
              sizes: @sizes,
              services: @services,
              categories: @categories,
              brands: @brands
            }
          end

          private

          def self.set_filters(aggs)
            @filters = {}
            @filters[:base_price] = generate_filter(aggs["base_price"]["buckets"]) if aggs["base_price"]
            @filters[:colors] = generate_filter(aggs["colors"]["buckets"]) if aggs["colors"] && aggs["colors"]["buckets"].count > 1
            @filters[:sizes] = generate_filter(aggs["sizes"]["buckets"]) if aggs["sizes"] && aggs["sizes"]["buckets"].count > 1
            @filters[:services] = generate_filter(aggs["services"]["buckets"]) if (aggs["services"] && aggs["services"]["buckets"].count > 1)
            @filters[:categories] = generate_filter_category(aggs["category_tree_ids"]["buckets"], aggs["category_id"]) if aggs["category_tree_ids"] && aggs["category_tree_ids"]["buckets"].count > 1
            @filters[:brands] = generate_filter(aggs["brand_name"]["buckets"]) if aggs["brand_name"] && aggs["brand_name"]["buckets"].count > 1
            @filters
          end

          def self.generate_filter(value)
            value.map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse
          end

          def self.generate_filter_category(value, current_category)
            counts = value.map { |item| [item["key"], item["doc_count"]] }.to_h
            categories = []
            back_to_categories = []
            current_category = ::Category.where(id: current_category).first

            if current_category
              categories = current_category.children
              back_to_categories << nil
              slugs = []
              parent_categories = current_category.slug.split('/')
              parent_categories.pop
              unless parent_categories.empty?
                parent_categories.each do |cat|
                  slugs << cat
                  category = ::Category.find_by(slug: slugs.join('/'))
                  back_to_categories << { name: category.name, slugs: category.slug }
                end
              end
            else
              categories = ::Category.greatest.non_explicit
            end

            categories = categories.map do |category|
              if counts[category.id] && counts[category.id] > 0
                { name: category.name, slugs: category.slug }
              end
            end.compact

            categories
          end
        end
      end
    end
  end
end