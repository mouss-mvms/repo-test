module V1
  module Examples
    module Response
      class ProductSummary
        def self.to_h
          {
            type: :object,
            properties: {
              _index: { type: :string, example: "products_v1_20210315162727103" },
              _id: { type: :string, example: "21034" },
              _type: { type: :string, example: "_doc" },
              _score: { type: :number, example: 0.9976985 },
              id: { type: :integer, example: 21034 },
              name: { type: :string, example: "MIRACLE : L'ENVOÛTANT PARFUM D'UN PÂTÉ BRASSÉ" },
              slug: { type: :string, example: "miracle-l-envoutant-parfum-d-un-pate-brasse" },
              createdAt: { type: :string, example: "2020-04-10T14:44:53.723+02:0" },
              updatedAt: { type: :string, example: "2020-04-10T14:46:26.902+02:00" },
              description: { type: :string, example: "Par cette collaboration, l’idée est de se fondre dans l’agrosystème mis en place entre l’éleveur du Prince Noir de Biscay et la brasserie Mira. Par ce mécanisme soigneusement orchestré, le bon sens commun et la culture raisonnée sont mis à l’honneur. C’est un retour aux fondamentaux, au sens de la vie, au « Miracle » de la vie.\r\n\r\nAccompagné de sa phrase « L’envoûtant parfum d’un pâté brassé », on retrouve l’évocation du charme envoûtant de cette bière brune et son parfum si délicat.\r\n\r\nIngrédients: Viande, gorge et foie de porc Prince noir de Biscay, Bière Brune de la Brasserie Mira, sel, poivre, ail et une pincée d’amour." },
              basePrice: { type: :number, example: 5.5 },
              goodDealStartsAt: { type: :string, example: "2020-04-10T14:44:53.723+02:0" },
              goodDealEndsAt: { type: :string, example: "2020-04-14T14:44:53.723+02:0" },
              price: { type: :number, example: "5.5" },
              quantity: { type: :integer, example: 100 },
              categoryId: { type: :integer, example: 2204 },
              categoryTreeNames: {
                type: :array,
                items: { type: :string, example: "Alimentation" }
              },
              categoryTreeIds: {
                type: :array,
                items: { type: :integer, example: 2054 }
              },
              status: { type: :string, example: "online" },
              shopName: { type: :string, example: "LES CONSERVISTES" },
              shopId: { type: :integer, example: 2088 },
              shopSlug: { type: :string, example: "shop_slug" },
              inHolidays: { type: :boolean, example: false },
              brandName: { type: :string, example: "LES CONSERVISTES" },
              brandId: { type: :integer, example: 4494 },
              cityName: { type: :string, example: "Bordeaux" },
              cityLabel: { type: :string, example: "Bordeaux" },
              citySlug: { type: :string, example: "bordeaux" },
              conurbationSlug: { type: :string, example: "bordeaux" },
              inseeCode: { type: :string, example: "33063" },
              territoryName: { type: :string, example: "Bordeaux Métropole" },
              territorySlug: { type: :string, example: "bordeaux-metropole" },
              departmentNumber: { type: :string, example: "33" },
              productCitizenNickname: { type: :string, example: "XxxDarkSasukexxX" },
              productCitizenSlug: { type: :string, example: "xxxdarksasuexxxx" },
              productCitizenImagePath: { type: :string, example: "https://mavillemonshopping-examples/uploads/development/image/8096/file/thumb-b04b1b37d90da7bae3200fef258666c0.jpg" },
              defaultSampleId: { type: :integer, example: 25301 },
              shopPictogramUrl: { type: :string, example: "https://mavillemonshopping-exemples.com/uploads/development/image/48072/file/thumb-417fqfsqfq958591c590cb5d0e619f38f.jpg" },
              imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" },
              productPageUrl: { type: :string, example: "https://mavillemonshopping-dev.herokuapp.com/fr/bordeaux/les-conservistes/alimentation/epicerie-salee/conserves-et-plats-cuisines/produits/miracle-l-envoutant-parfum-d-un-pate-brasse" },
              shopUrl: { type: :string, example: "/fr/bordeaux/boutiques/les-conservistes" },
              numberOfOrders: { type: :integer, example: 3 },
              colors: {
                type: :array,
                items: { type: :string, example: "Modèle par défaut" }
              },
              sizes: {
                type: :array,
                items: { type: :string, example: "40" }
              },
              selectionIds: {
                type: :array,
                items: { type: :integer, example: 30 }
              },
              services: {
                type: :array,
                items: { type: :string, example: "e-reservation" }
              },
              shopIsTemplate: { type: :boolean, example: false },
              score: { type: :integer, example: 0 },
              position: { type: :integer, example: 480 },
              indexedAt: { type: :string, example: "2021-07-30T10:29:24.113+02:00" },
              uniqueReferenceId: { type: :integer, example: 1356 },
              isAService: { type: :boolean, example: true },
              onDisount: { type: :boolean, example: true },
              disountPrice: { type: :number, example: 50.5 }
            }
          }
        end
      end
    end
  end
end