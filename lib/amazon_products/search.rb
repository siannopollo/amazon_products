module AmazonProducts
  class Search
    include AmazonProducts::Retrieval
    
    def execute
      item_search = AmazonProducts::ItemSearch.new index, search_by => identifier
      response_group = AmazonProducts::ResponseGroup.new response_group_size
      request = AmazonProducts::Request.new AmazonProducts.access_key_id, nil, 'us'
      
      SearchResultCollection.new request.search(item_search, response_group), index
    end
    
    protected
      def default_search_by
        'Title'
      end
  end
  
  class SearchResultCollection < Array
    def initialize(search_response, search_index)
      items = search_response.item_search_response[0].items[0].item
      items.each { |item| self.push Product.create(item, search_index) }
      compact!
    end
  end
end