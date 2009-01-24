module AmazonProducts
  # Products are just items brought back by an AmazonProduct::Search.
  #
  # To find out what methods are available to a particular Product, just
  # inspect the #attribute_names method. This can be useful since these
  # attributes change with the type of AmazonProducts::ResponseGroup used. So
  # a 'Medium' ResponseGroup size will return more attributes than 'Small' and
  # less than 'Large'.
  #
  class Product
    def self.create(item, search_index)
      product_group = item.item_attributes.first.product_group.to_s.gsub(' ', '')
      (search_index == :any || search_index.match(product_group)) ? AmazonProducts.const_get(product_group).new(item) : nil
    end
    
    attr_reader :attribute_names
    
    def initialize(item)
      @item = item
      @item_attributes = @item.item_attributes
      @attribute_names = @item_attributes.properties
    end
    
    def asin
      @asin ||= @item['asin'].to_s
    end
    
    def large_image
      @large_image ||= Image.new(@item['large_image'])
    end
    
    def medium_image
      @medium_image ||= Image.new(@item['medium_image'])
    end
    
    def small_image
      @small_image ||= Image.new(@item['small_image'])
    end
    
    protected
      def method_missing(method, *args)
        return super unless @attribute_names.include?(method.to_s)
        @item_attributes.first.send(method).to_s
      end
  end
  
  class Book < Product
    def author
      @item_attributes.first.author.collect {|name| name.to_s}
    end
    alias_method :authors, :author
    
    def format
      @item_attributes.first.format
    end
    
    def language
      @item_attributes.languages.language.first.name.to_s
    end
    
    def number_of_items
      number_ofitems
    end
    
    def number_of_pages
      number_ofpages
    end
  end
  
  class Music < Product
    def number_of_discs
      number_ofdiscs
    end
  end
  
  class DVD < Product
    def actors
      actor.collect {|name| name.to_s}
    end
    
    # Returns an array of items as such:
    # 
    #   [{"Writer"=>"Jared Hess"}, {"Producer"=>"Chris Wyatt"}... ]
    # 
    def creators
      @item_attributes.first.creator.inject([]) {|m,c| m << {c.attrib['role'] => c.to_s}}
    end
    
    # This is a pretty crazy attribute, so this will just be passed through to
    # do with what you wish
    def format
      @item_attributes.first.format
    end
    
    # This is also a pretty crazy attribute, so this will just be passed
    # through to do with what you wish
    def languages
      @item_attributes.first.languages
    end
    
    def number_of_items
      number_ofitems
    end
  end
  
  class VideoGame < Product; end
  VideoGames = VideoGame
  
  class Image
    attr_reader :height, :width, :url
    
    def initialize(image)
      @height = image.height.first.to_i
      @width = image.width.first.to_i
      @url = image.url.first.to_s
    end
  end
end