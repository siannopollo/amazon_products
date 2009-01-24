require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AmazonProducts::Search do
  before do
    @model = AmazonProducts::Search.new('ruby programming', :index => 'Books')
  end
  
  it 'should set index and identifier upon instantiation' do
    @model.index.should == 'Books'
    @model.identifier.should == 'ruby programming'
  end
  
  it 'should default to returning a medium response group size' do
    @model.response_group_size.should == 'Medium'
  end
  
  it 'should default to searching by title' do
    @model.search_by.should == 'Title'
  end
  
  it 'should search for items' do
    request = Object.new
    AmazonProducts::Request.should_receive(:new).and_return(request)
    request.should_receive(:search)
    
    collection = Object.new
    AmazonProducts::SearchResultCollection.should_receive(:new).and_return(collection)
    
    returned_collection = @model.execute
    returned_collection.should == collection
  end
end