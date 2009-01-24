module AmazonProducts
  class Search
    attr_reader :index, :response_group_size, :search_by, :identifier
    
    def initialize(index, identifier, response_group_size = 'Medium', search_by = 'Title')
      @index, @identifier, @response_group_size, @search_by =
        index, identifier, response_group_size, search_by
    end
    
    def execute
      item_search = AmazonProducts::ItemSearch.new index, 'Title' => identifier
      response_group = AmazonProducts::ResponseGroup.new response_group_size
      request = AmazonProducts::Request.new AmazonProducts.access_key_id, nil, 'us'
      
      SearchResultCollection.new request.search(item_search, response_group), index
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