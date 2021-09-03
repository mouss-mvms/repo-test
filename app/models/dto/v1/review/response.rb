module Dto
  module V1
    module Review
      class Response
        attr_reader :id, :content, :mark, :shop_id, :product_id, :parent_id, :user_id, :answers

        def initialize(**args)
          @id = args[:id]
          @content = args[:content]
          @mark = args[:mark]
          @shop_id = args[:shop_id]
          @user_id = args[:user_id]
          @parent_id = args[:parent_id]
          @product_id = args[:product_id]
          @answers = []
          args[:answers].each do |answer|
            @answers << answer
          end
        end

        def self.create(review)
          answers = []
          review.answers.each do |answer|
            answers << Dto::V1::Review::Response.create(answer)
          end
          Dto::V1::Review::Response.new({
                                          id: review.id,
                                          content: review.content,
                                          mark: review.mark,
                                          shop_id: review.shop_id,
                                          product_id: review.product_id,
                                          user_id: review.user_id,
                                          parent_id: review.parent_id,
                                          answers: answers
                                        })
        end

        def to_h
          {
            id: @id,
            content: @content,
            mark: @mark,
            shopId: @shop_id,
            productId: @product_id,
            parentId: @parent_id,
            userId: @user_id,
            answers: @answers
          }
        end
      end
    end
  end
end
