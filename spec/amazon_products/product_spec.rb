require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# These specs go out and touch Amazon, so an internet connection is needed to
# run these

describe 'Amazon' do
  before :all do
    @book = AmazonProducts::Lookup.new('0596516177').execute # The Ruby Programming Language
    @music = AmazonProducts::Lookup.new('B00000053E').execute # Jars of Clay CD
    @dvd = AmazonProducts::Lookup.new('B00005JNBQ').execute # Napoleon Dynamite DVD
    @video_game = AmazonProducts::Lookup.new('B000FQ9QVI').execute # Super Mario Galaxy (Wii)
  end
  
  describe 'Books' do
    before do
      @product = @book
    end
    
    it 'should reflect the type of item it is' do
      @product.should be_kind_of(AmazonProducts::Book)
    end
    
    it 'should have extra attribute names' do
      @product.attribute_names.should include('authors', 'number_of_items', 'number_of_pages')
    end
    
    it 'should respond to certain methods' do
      @product.attribute_names.each do |method|
        @product.send(method).should_not be_nil
      end
    end
  end
  
  describe 'Music' do
    before do
      @product = @music
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
    before do
      @product = @dvd
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
    before do
      @product = @video_game
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
    before do
      @product = @dvd
    end
    
    it 'should look nice' do
      @product.package_dimensions.to_s.should == '7.4 x 5.4 x 0.6 inches; 0.15 pounds'
      @product.package_dimensions.length.to_s.should == '7.4 inches'
    end
  end
  
  describe 'YAML dumping' do
    it 'should not dump any of the AWSObject objects, but should use their value' do
      [@book, @dvd, @music, @video_game].each do |product|
        hash = {}
        product.attribute_names.each do |attribute|
          hash[attribute] = (product.send(attribute) rescue nil)
        end
        yaml = YAML::dump hash
        yaml.should_not match(/(Amazon::AWS::AWSObject::\w+)/)
      end
    end
  end
end