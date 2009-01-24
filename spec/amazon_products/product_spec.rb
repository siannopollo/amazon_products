require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# These specs go out and touch Amazon, so an internet connection is needed to
# run these

DefaultProductMethods = %w(asin small_image medium_image large_image)

describe 'Books' do
  before :all do
    @search = AmazonProducts::Lookup.new('0596516177', :index => 'Books', :search_by => 'ISBN') # The Ruby Programming Language
    @result = @search.execute
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::Book)
  end
  
  it 'should respond to certain methods' do
    @result.attribute_names.concat(DefaultProductMethods).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end

describe 'Music' do
  before :all do
    @search = AmazonProducts::Lookup.new('B00000053E') # Jars of Clay CD
    @result = @search.execute
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::Music)
  end
  
  it 'should respond to certain methods' do
    @result.attribute_names.concat(DefaultProductMethods).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end

describe 'DVD' do
  before :all do
    @search = AmazonProducts::Lookup.new('B00005JNBQ') # Napoleon Dynamite DVD
    @result = @search.execute
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::DVD)
  end
  
  it 'should respond to certain methods' do
    @result.attribute_names.concat(DefaultProductMethods).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end

describe 'VideoGame' do
  before :all do
    @search = AmazonProducts::Lookup.new('B000FQ9QVI') # Super Mario Galaxy (Wii)
    @result = @search.execute
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::VideoGame)
  end
  
  it 'should respond to certain methods' do
    @result.attribute_names.concat(DefaultProductMethods).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end