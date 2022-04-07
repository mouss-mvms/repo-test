module V1
  module Examples
    module Response
      class Selection
        def self.to_h
          {
            type: 'object',
            properties: {
              id: { type: :integer, example: 42, description: "Unique identifier of the selection." },
              name: { type: :string, example: "voiture", description: 'Selection name.' },
              slug: { type: :string, example: 'voiture-1', description: 'Selection slug.' },
              description: { type: :string, example: "Selection de voitures.", description: 'Description of the selection.' },
              tagIds: {
                type: :array,
                items: { type: :integer, example: "12", description: 'Tag id.' }
              },
              startAt: { type: :string, example: "20/07/2021", description: "Date of start of selection." },
              endAt: { type: :string, example: "27/07/2021", description: "Date of end of selection." },
              homePage: { type: :boolean, example: false, description: 'Show the selection at home.' },
              event: { type: :boolean, example: false, description: 'Selection is an event.' },
              state: {
                type: :string,
                enum: ["active", "inactive"]
              },
              order: { type: :integer, example: 79, description: "Order of the  selection." },
              image: { '$ref': '#/components/schemas/Image' },
              productsCount: { type: :integer, example: 100, description: "Number of a selection's produ" },
              cover: { '$ref': '#/components/schemas/Image' },
              promoted: { type: :boolean, example: false, description: 'Selection is promoted.' },
              longDescription: {
                type: :text,
                example: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
                  Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
                  Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit.",
                description: "Unlimited characters description"
              }
            }
          }
        end
      end
    end
  end
end
