module V1
  module Examples
    module Response
      class ShopSummary
        def self.to_h
          {
            type: :object,
            properties: {
              _index: { type: :string, example: "shops_v1_20210315162727103" },
              _type: { type: :string, example: "_doc" },
              _id: { type: :string, example: "42" },
              _score: { type: :number, example: 0.9996825 },
              id: { type: :string, example: "42" },
              name: { type: :string, example: "Ray's occult books" },
              createdAt: { type: :string, example: "2020-04-11T20:22:29.446+02:00" },
              updatedAt: { type: :string, example: "2021-05-06T17:14:04.816+02:00" },
              slug: { type: :string, example: "ray-s-occult-books" },
              shopUrl: { type: :string, example: "/us/new-york/boutiques/ray-s-occult-books" },
              categoryTreeIds: {
                type: :array,
                items: {
                  type: :integer, example: [42, 43],
                },
              },
              categoryTreeNames: {
                type: :array,
                items: {
                  type: :string, example: ["Books", "Occultism"],
                },
              },
              baseline: { type: :string, example: "We are open until 7:00 P.M. on weekdays, midnight on Saturdays" },
              description: { type: :string, example: "Ray's Occult books opened in 1986 and we specializing in the bizarre, somewhat strange, and hard to find books. If we don't got it we can get it." },
              brandsName: {
                type: :array,
                items: {
                  type: :string, example: ["Book brand", "Book brand", "Book brand"],
                },
              },
              cityLabel: { type: :string, example: "New York" },
              citySlug: { type: :string, example: "new-york" },
              inseeCode: { type: :string, example: "44084" },
              territoryName: { type: :string, example: "Usa" },
              territorySlug: { type: :string, example: "usa" },
              departmentNumber: { type: :string, example: "44" },
              deletedAt: { type: :string, example: nil },
              numberOfOnlineProducts: { type: :integer, example: 233 },
              numberOfOrders: { type: :integer, example: 5 },
              imageUrl: { type: :string, example: "https://static.wikia.nocookie.net/ghostbusters/images/e/e0/GB2film1999chapter04sc001.png/revision/latest?cb=20111220104753" },
              coupons: { type: :string, example: "[]" },
              pictogram_url: { type: :string, example: nil },
              services: {
                type: :array,
                items: {
                  type: :string, example: ["click-collect", "drone", "helicopter"],
                },
              },
              isTemplate: { type: :boolean, example: false },
              score: { type: :integer, example: 5 },
              indexed_at: { type: :string, example: "2021-06-28T11:09:54.088+00:00" },
            },
          }
        end
      end
    end
  end
end
