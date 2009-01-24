require 'amazon/aws'
require 'amazon/aws/search'
require 'yaml'

module AmazonProducts
  class << self
    attr_accessor :config_location
    
    def access_key_id
      @access_key_id ||= YAML.load_file(config_location)['access_key_id']
    end
  end
  
  include Amazon::AWS
  include Amazon::AWS::Search
  
  module Retrieval
    def self.included(base)
      base.module_eval do
        attr_reader :identifier, :index, :response_group_size, :search_by
      end
    end
    
    def initialize(identifier, options = {})
      @identifier = identifier
      @index = options[:index]
      @search_by = options[:search_by] || default_search_by
      @response_group_size = options[:response_group_size] || 'Medium'
    end
  end
end
require 'amazon_products/search'
require 'amazon_products/lookup'
require 'amazon_products/product'
