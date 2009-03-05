require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# These specs go out and touch Amazon, so an internet connection is needed to
# run these

describe 'Books' do
  before :all do
    @product = AmazonProducts::Lookup.new('0596516177', :index => 'Books', :search_by => 'ISBN').execute # The Ruby Programming Language
  end
  
  it 'should reflect the type of item it is' do
    @product.should be_kind_of(AmazonProducts::Book)
  end
  
  it 'should have extra attribute names' do
    @product.attribute_names.should include('authors', 'language', 'number_of_items', 'number_of_pages')
  end
  
  it 'should respond to certain methods' do
    @product.attribute_names.each do |method|
      @product.send(method).should_not be_nil
    end
  end
end

describe 'Music' do
  before :all do
    @product = AmazonProducts::Lookup.new('B00000053E').execute # Jars of Clay CD
  end
  
  it 'should reflect the type of item it is' do
    @product.should be_kind_of(AmazonProducts::Music)
  end
  
  it 'should have extra attribute names' do
    @product.attribute_names.should include('number_of_discs')
  end
  
  it 'should respond to certain methods' do
    @product.attribute_names.each do |method|
      @product.send(method).should_not be_nil
    end
  end
end

describe 'DVD' do
  before :all do
    @product = AmazonProducts::Lookup.new('B00005JNBQ').execute # Napoleon Dynamite DVD
  end
  
  it 'should reflect the type of item it is' do
    @product.should be_kind_of(AmazonProducts::DVD)
  end
  
  it 'should have extra attribute names' do
    @product.attribute_names.should include('actors', 'creators')
  end
  
  it 'should respond to certain methods' do
    @product.attribute_names.each do |method|
      @product.send(method).should_not be_nil
    end
  end
end

describe 'VideoGame' do
  before :all do
    @product = AmazonProducts::Lookup.new('B000FQ9QVI').execute # Super Mario Galaxy (Wii)
  end
  
  it 'should reflect the type of item it is' do
    @product.should be_kind_of(AmazonProducts::VideoGame)
  end
  
  it 'should respond to certain methods' do
    @product.attribute_names.each do |method|
      @product.send(method).should_not be_nil
    end
  end
  
  it 'should return an array of sentences for feature' do
    @product.feature.should be_a_kind_of(Array)
    @product.feature.each do |f|
      f.should be_a_kind_of(String)
    end
  end
end

describe 'PackageDimensions' do
  before :all do
    @product = AmazonProducts::Lookup.new('B000CRQX34').execute
  end
  
  it 'should look nice' do
    @product.package_dimensions.to_s.should == '7.5 x 5.4 x 0.9 inches; 0.25 pounds'
    @product.package_dimensions.length.to_s.should == '7.5 inches'
  end
end