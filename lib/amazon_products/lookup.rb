module AmazonProducts
  class Lookup
    attr_reader :identifier, :index, :response_group_size, :search_by
    
    def initialize(identifier, search_by = 'ASIN', index = nil, response_group_size = 'Medium')
      @identifier, @search_by, @index, @response_group_size =
        identifier, search_by, index, response_group_size
    end
    
    def execute
      item_lookup = AmazonProducts::ItemLookup.new search_by, parameters
      response_group = AmazonProducts::ResponseGroup.new response_group_size
      request = AmazonProducts::Request.new AmazonProducts.access_key_id, nil, 'us'
      response = request.search(item_lookup, response_group)
      
      Product.create(response.item_lookup_response.first.items.first.item.first, index || :any)
    end
    
    protected
      def parameters
        params = {'ItemId' => identifier}
        params.update('SearchIndex' => index) unless index.nil?
        params
      end
  end
end