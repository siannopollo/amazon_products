module AmazonProducts
  class Search
    attr_reader :index, :response_group_size, :search_by, :term
    
    def initialize(index, term, response_group_size = 'Medium', search_by = 'Title')
      @index, @term, @response_group_size, @search_by =
        index, term, response_group_size, search_by
    end
    
    def search!
      item_search = AmazonProducts::ItemSearch.new index, 'Title' => term
      response_group = AmazonProducts::ResponseGroup.new response_group_size
      request = AmazonProducts::Request.new AmazonProducts.access_key_id, nil, 'us'
      
      SearchResultCollection.new request.search(item_search, response_group), index
    end
  end
  
  class SearchResultCollection
    attr_reader :results, :search_index, :search_response
    
    def initialize(search_response, search_index)
      @search_response, @search_index = search_response, search_index
      @results = []
      items = @search_response.item_search_response[0].items[0].item
      items.each { |item| @results << Product.create(item, search_index) }
      @results.compact!
    end
    
    def method_missing(method, *args)
      return results.send(method, *args) if results.respond_to?(method)
      super
    end
  end
end