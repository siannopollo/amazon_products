require 'spec'
require File.expand_path(File.dirname(__FILE__)) + '/../init'

AmazonProducts.config_location = File.expand_path(__FILE__ + '/../../config/amazon.yml')

module Kernel
  def rputs(*args)
    print "<pre><br/>", args.collect {|a| a.inspect}, "<br/></pre>"
  end
end
