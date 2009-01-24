require 'amazon/aws'
require 'amazon/aws/search'
require 'yaml'

require 'amazon_products/search'
require 'amazon_products/lookup'
require 'amazon_products/product'

module AmazonProducts
  class << self
    attr_accessor :config_location
    
    def access_key_id
      @access_key_id ||= YAML.load_file(config_location)['access_key_id']
    end
  end
  
  include Amazon::AWS
  include Amazon::AWS::Search
end