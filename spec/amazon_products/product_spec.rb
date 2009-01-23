require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Books' do
  before :all do
    @search = AmazonProducts::Search.new('Books', 'ruby programming')
    @result_collection = @search.search!
    @result = @result_collection.first
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::Book)
  end
  
  it 'should respond to certain methods' do
    %w(asin small_image medium_image large_image title author binding number_of_pages isbn language number_of_items).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end