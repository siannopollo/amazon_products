module AmazonProducts
  class Product
    def self.create(item)
      AmazonProducts.const_get(item['item_attributes'].product_group.to_s).new(item)
    end
    
    def initialize(item)
      @item = item
      @item_attributes = @item.item_attributes
      @attribute_names = @item_attributes.properties
    end
    
    def asin
      @small_image ||= @item['asin'].to_s
    end
    
    def language
      @item_attributes.languages.language.first.name.to_s
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
    
    def number_of_items
      number_ofitems
    end
    
    def method_missing(method, *args)
      return super unless @attribute_names.include?(method.to_s)
      @item_attributes.first.send(method).first.to_s
    end
  end
  
  # Some of the methods available to a Book:
  #
  # * <tt>:author</tt>
  # * <tt>:binding</tt> - Values like 'Hardcover' or 'Paperback'
  # * <tt>:dewey_decimal_number</tt>
  # * <tt>:ean</tt> - European Article Number, superset of UPC
  # * <tt>:format</tt> - Values like 'Illustrated'
  # * <tt>:isbn</tt> - International Standard Book Number
  # * <tt>:label</tt>
  # * <tt>:language</tt>
  # * <tt>:list_price</tt>
  # * <tt>:manufacturer</tt>
  # * <tt>:number_of_items</tt>
  # * <tt>:number_of_pages</tt>
  # * <tt>:package_dimensions</tt>
  # * <tt>:product_group</tt> - Should be 'Book'
  # * <tt>:product_type_name</tt>
  # * <tt>:publication_date</tt>
  # * <tt>:publisher</tt>
  # * <tt>:studio</tt>
  # * <tt>:title</tt>
  #
  class Book < Product
    def number_of_pages
      number_ofpages
    end
  end
  
  class Image
    def initialize(image)
      @height = image.height.first.to_i
      @width = image.width.first.to_i
      @url = image.url.first.to_s
    end
  end
end