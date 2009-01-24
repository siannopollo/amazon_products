module AmazonProducts
  class Lookup
    include AmazonProducts::Retrieval
    
    def execute
      item_lookup = AmazonProducts::ItemLookup.new search_by, parameters
      response_group = AmazonProducts::ResponseGroup.new response_group_size
      request = AmazonProducts::Request.new AmazonProducts.access_key_id, nil, 'us'
      response = request.search(item_lookup, response_group)
      
      Product.create(response.item_lookup_response.first.items.first.item.first, index || :any)
    end
    
    protected
      def default_search_by
        'ASIN'
      end
      
      def parameters
        params = {'ItemId' => identifier}
        params.update('SearchIndex' => index) unless index.nil?
        params
      end
  end
end