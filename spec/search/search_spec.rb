require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AmazonProducts::Search do
  before do
    @model = AmazonProducts::Search.new('Books', 'ruby programming')
  end
  
  it 'should set index and term upon instantiation' do
    @model.index.should == 'Books'
    @model.term.should == 'ruby programming'
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
    AmazonProducts::SearchResultCollection.should_receive(:new)
    
    @model.search!
  end
end

describe AmazonProducts::SearchResultCollection do
  before :all do
    @search = AmazonProducts::Search.new('Books', 'ruby programming', 'Large')
    @model = @search.search!
  end
  
  it 'should have search results' do
    @model.size.should > 1
  end
end