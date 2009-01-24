module AmazonProducts
  class Lookup
    attr_reader :identifier, :response_group_size, :search_by
    
    def initialize(identifier, search_by = 'ASIN', response_group_size = 'Medium')
      @identifier, @search_by, @response_group_size = identifier, search_by, response_group_size
    end
    
    def execute
      item_lookup = AmazonProducts::ItemLookup.new search_by, 'ItemId' => identifier
      response_group = AmazonProducts::ResponseGroup.new response_group_size
      request = AmazonProducts::Request.new AmazonProducts.access_key_id, nil, 'us'
      response = request.search(item_lookup, response_group)
      
      Product.create(response.item_lookup_response.first.items.first.item.first, :any)
    end
  end
end