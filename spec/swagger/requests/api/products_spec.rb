require 'swagger_helper'

RSpec.describe 'api/categories', type: :request do
  path '/api/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'

    put('Update a product (offline)') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Return the product updated'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, example: "Air jordan", description: 'Name of product'},
          description: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          brand: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          status: {type: :string, example: "online", description: 'Status of product'},
          sellerAdvice: {type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product'},
          isService: {type: :boolean, example: false, description: 'Tell if the product is a service'},
          citizenAdvice: {type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product'},
          categoryId: {type: :integer, example: 4, description: 'Category id of product'},
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                basePrice: {type: :float, example: 44.99, description: "Price of product's variant"},
                weight: {type: :float, example: 0.56, description: "Weight of product's variant (in Kg)"},
                quantity: {type: :integer, example: 9, description: "Stock of product's variant"},
                isDefault: {type: :boolean, example: true, description: "Tell if this variant is the product's default variant"},
                goodDeal: {
                  type: :object,
                  properties: {
                    startAt: {type: :string, example: "20/07/2021", description: "Date of start of good deal"},
                    endAt: {type: :string, example: "27/07/2021", description: "Date of end of good deal"},
                    discount: {type: :integer, example: 45, description: "Amount of discount (in %)"}
                  },
                  required: %w[startAt, endAt, discount]
                },
                characteristic: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {type: :string, example: 'color', description: 'Name of characteristic'},
                      value: {type: :string, example: 'Bleu', description: 'Value of characteristic'}
                    },
                    required: %w[name, value]
                  }
                }
              },
              required: %w[basePrice, weight, quantity, isDefault]
            }
          },
          origin: {type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)'},
          allergens: {type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)'},
          composition: {type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)'}
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
      }

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/BadRequest'}
               }
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/NotFound'}
               }
        run_test!
      end
    end

    delete('Delete a product (offline)') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Delete a product'
      security [{ authorization: [] }]

      response(204, 'OK') do
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/BadRequest'}
               }
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/NotFound'}
               }
        run_test!
      end
    end

    get('Retrieve a product') do
      tags 'Products'
      produces 'application/json'
      description 'Retrieve a product'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/NotFound'}
               }
        run_test!
      end
    end
  end

  path '/api/auth/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'
    parameter name: 'X-client-id', in: :header

    put('Update a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Return the product updated'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, example: "Air jordan", description: 'Name of product'},
          description: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          brand: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          status: {type: :string, example: "online", description: 'Status of product'},
          sellerAdvice: {type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product'},
          isService: {type: :boolean, example: false, description: 'Tell if the product is a service'},
          citizenAdvice: {type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product'},
          categoryId: {type: :integer, example: 4, description: 'Category id of product'},
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                basePrice: {type: :float, example: 44.99, description: "Price of product's variant"},
                weight: {type: :float, example: 0.56, description: "Weight of product's variant (in Kg)"},
                quantity: {type: :integer, example: 9, description: "Stock of product's variant"},
                isDefault: {type: :boolean, example: true, description: "Tell if this variant is the product's default variant"},
                goodDeal: {
                  type: :object,
                  properties: {
                    startAt: {type: :string, example: "20/07/2021", description: "Date of start of good deal"},
                    endAt: {type: :string, example: "27/07/2021", description: "Date of end of good deal"},
                    discount: {type: :integer, example: 45, description: "Amount of discount (in %)"}
                  },
                  required: %w[startAt, endAt, discount]
                },
                characteristic: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {type: :string, example: 'color', description: 'Name of characteristic'},
                      value: {type: :string, example: 'Bleu', description: 'Value of characteristic'}
                    },
                    required: %w[name, value]
                  }
                }
              },
              required: %w[basePrice, weight, quantity, isDefault]
            }
          },
          origin: {type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)'},
          allergens: {type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)'},
          composition: {type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)'}
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
      }

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Unauthorized'}
               }
        run_test!
      end

      response(403, 'Forbidden') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Forbidden'}
               }
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/NotFound'}
               }
        run_test!
      end
    end

    delete('Delete a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Delete a product'
      security [{ authorization: [] }]

      response(204, 'Product deleted') do
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/BadRequest'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Unauthorized'}
               }
        run_test!
      end

      response(403, 'Forbidden') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Forbidden'}
               }
        run_test!
      end
    end
  end

  path '/api/auth/products' do
    post('Create a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Return the product created'
      security [{ authorization: [] }]

      parameter name: 'X-client-id', in: :header

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, example: "Air jordan", description: 'Name of product'},
          description: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          brand: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          status: {type: :string, example: "online", description: 'Status of product'},
          sellerAdvice: {type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product'},
          isService: {type: :boolean, example: false, description: 'Tell if the product is a service'},
          citizenAdvice: {type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product'},
          categoryId: {type: :integer, example: 4, description: 'Category id of product'},
          shopId: {type: :integer, example: 453, description: 'Shop id of product'},
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                basePrice: {type: :float, example: 44.99, description: "Price of product's variant"},
                weight: {type: :float, example: 0.56, description: "Weight of product's variant (in Kg)"},
                quantity: {type: :integer, example: 9, description: "Stock of product's variant"},
                isDefault: {type: :boolean, example: true, description: "Tell if this variant is the product's default variant"},
                goodDeal: {
                  type: :object,
                  properties: {
                    startAt: {type: :string, example: "20/07/2021", description: "Date of start of good deal"},
                    endAt: {type: :string, example: "27/07/2021", description: "Date of end of good deal"},
                    discount: {type: :integer, example: 45, description: "Amount of discount (in %)"}
                  },
                  required: %w[startAt, endAt, discount]
                },
                characteristic: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {type: :string, example: 'color', description: 'Name of characteristic'},
                      value: {type: :string, example: 'Bleu', description: 'Value of characteristic'}
                    },
                    required: %w[name, value]
                  }
                }
              },
              required: %w[basePrice, weight, quantity, isDefault]
            }
          },
          origin: {type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)'},
          allergens: {type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)'},
          composition: {type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)'}
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
      }

      response(201, 'Product created') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/BadRequest'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Unauthorized'}
               }
        run_test!
      end

      response(403, 'Forbidden') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Forbidden'}
               }
        run_test!
      end
    end
  end

  path '/api/products' do
    post('Create a product (offline)') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Return the product created'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, example: "Air jordan", description: 'Name of product'},
          description: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          brand: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
          status: {type: :string, example: "online", description: 'Status of product'},
          sellerAdvice: {type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product'},
          isService: {type: :boolean, example: false, description: 'Tell if the product is a service'},
          citizenAdvice: {type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product'},
          categoryId: {type: :integer, example: 4, description: 'Category id of product'},
          shopId: {type: :integer, example: 453, description: 'Shop id of product'},
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                basePrice: {type: :float, example: 44.99, description: "Price of product's variant"},
                weight: {type: :float, example: 0.56, description: "Weight of product's variant (in Kg)"},
                quantity: {type: :integer, example: 9, description: "Stock of product's variant"},
                isDefault: {type: :boolean, example: true, description: "Tell if this variant is the product's default variant"},
                goodDeal: {
                  type: :object,
                  properties: {
                    startAt: {type: :string, example: "20/07/2021", description: "Date of start of good deal"},
                    endAt: {type: :string, example: "27/07/2021", description: "Date of end of good deal"},
                    discount: {type: :integer, example: 45, description: "Amount of discount (in %)"}
                  },
                  required: %w[startAt, endAt, discount]
                },
                characteristic: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {type: :string, example: 'color', description: 'Name of characteristic'},
                      value: {type: :string, example: 'Bleu', description: 'Value of characteristic'}
                    },
                    required: %w[name, value]
                  }
                }
              },
              required: %w[basePrice, weight, quantity, isDefault]
            }
          },
          origin: {type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)'},
          allergens: {type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)'},
          composition: {type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)'}
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
      }

      response(201, 'Created') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/BadRequest'}
               }
        run_test!
      end
    end
  end
end
