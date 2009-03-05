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
    
    def initialize(item)
      @item = item
      @item_attributes = @item.item_attributes
      @attribute_names = @item_attributes.properties.dup
      @attribute_names.concat %w(asin small_image medium_image large_image)
    end
    
    def asin
      @asin ||= @item.asin.to_s
    end
    
    def attribute_names
      @attribute_names.sort
    end
    
    def binding
      @binding ||= @item_attributes.first['binding'].to_s
    end
    
    def large_image
      @large_image ||= Image.new(@item.large_image)
    end
    
    def medium_image
      @medium_image ||= Image.new(@item.medium_image)
    end
    
    def small_image
      @small_image ||= Image.new(@item.small_image)
    end
    
    def package_dimensions
      @package_dimensions ||= PackageDimensions.new(@item_attributes.first.package_dimensions.first)
    end
    
    protected
      def method_missing(method, *args)
        return super unless @attribute_names.include?(method.to_s)
        @item_attributes.first[method.to_s].to_s
      end
  end
  
  class Book < Product
    def initialize(item)
      super
      @attribute_names.concat %w(authors language number_of_items number_of_pages)
    end
    
    def author
      @item_attributes.first.author.collect {|name| name.to_s}
    end
    alias_method :authors, :author
    
    # Returns either nil, or a format (such as 'Illustrated', or 'Hardcover')
    # 
    def format
      f = @item_attributes.first.format
      f.to_s unless f.nil?
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
    def initialize(item)
      super
      @attribute_names.concat %w(number_of_discs)
    end
    
    def number_of_discs
      number_ofdiscs
    end
  end
  
  class DVD < Product
    def initialize(item)
      super
      @attribute_names.concat %w(actors creators number_of_items)
    end
    
    def actors
      @item_attributes.first.actor.collect {|name| name.to_s}
    end
    
    # Returns an array of items as such:
    # 
    #   [{"Writer"=>"Jared Hess"}, {"Producer"=>"Chris Wyatt"}... ]
    # 
    def creators
      @item_attributes.first.creator.inject([]) {|m,c| m << {c.attrib['role'] => c.to_s}}
    end
    
    # Returns an array of all the formats as such:
    # 
    #   ["AC-3", "Box set", "Color", "Dolby", "Dubbed", "DVD-Video", "Subtitled", "Widescreen", "NTSC"]
    # 
    def format
      @item_attributes.first.format.collect {|f| f.to_s}
    end
    
    # This is a pretty crazy attribute, so this will just be passed
    # through to do with what you wish
    def languages
      @item_attributes.first.languages
    end
    
    def number_of_items
      number_ofitems
    end
    
    # Returns a string, like "92 minutes"
    # 
    def running_time
      rt = @item_attributes.first.running_time.first
      "#{rt.to_s} #{rt.attrib['units']}"
    end
  end
  
  class VideoGame < Product
    def initialize(item)
      super
      @attribute_names.concat %w(number_of_discs)
    end
    
    # Returns an array of sentences describing the game.
    #
    def feature
      @item_attributes.feature.collect {|f| f.to_s}
    end
    
    def number_of_discs
      number_ofdiscs
    end
  end
  VideoGames = VideoGame
  
  class Image
    attr_reader :height, :width, :url
    
    def initialize(image)
      @url = (image.url.first.to_s rescue nil)
      @width = (image.width.first.to_i rescue nil)
      @height = (image.height.first.to_i rescue nil)
    end
  end
  
  class PackageDimensions
    def initialize(dimensions)
      @length = dimensions.length.first
      @width  = dimensions.width.first
      @height = dimensions.height.first
      @weight = dimensions.weight.first
      
      @length_units = @length.attrib['units']
      @width_units  = @width.attrib['units']
      @height_units = @height.attrib['units']
      @weight_units = @weight.attrib['units']
    end
    
    def length
      @real_length ||= Dimension.new(@length, @length_units)
    end
    
    def width
      @real_width ||= Dimension.new(@width, @width_units)
    end
    
    def height
      @real_height ||= Dimension.new(@height, @height_units)
    end
    
    def weight
      @real_weight ||= Dimension.new(@weight, @weight_units)
    end
    
    def to_s
      if [length.units, width.units, height.units].uniq == [length.units]
        values, extra = [length.value, width.value, height.value], " #{length.units}"
      else
        values, extra = [length, width, height], ''
      end
      
      "#{values.collect {|v| v.to_s}.join(' x ')}#{extra}; #{weight.to_s}"
    end
  end
  
  class Dimension
    def initialize(value, total_units)
      @value, @total_units = value, total_units
    end
    
    def decimal_place
      @total_units.split('-').first
    end
    
    def multiplier
      case decimal_place
      when 'hundredths' then 0.01
      end
    end
    
    def units
      @total_units.split('-').last
    end
    
    def value
      @value.to_i * multiplier
    end
    
    def to_s
      "#{value} #{units}"
    end
  end
end