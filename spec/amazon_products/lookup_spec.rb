require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AmazonProducts::Lookup do
  before do
    @model = AmazonProducts::Lookup.new('0596516177')
  end
  
  it 'should set index and term upon instantiation' do
    @model.search_by.should == 'ASIN'
    @model.identifier.should == '0596516177'
  end
  
  it 'should default to returning a medium response group size' do
    @model.response_group_size.should == 'Medium'
  end
  
  it 'should search for items' do
    product = @model.execute
    product.title.should == 'The Ruby Programming Language'
    product.authors.should == ['David Flanagan', 'Yukihiro Matsumoto']
  end
end