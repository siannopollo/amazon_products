require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# These specs go out and touch Amazon, so an internet connection is needed to
# run these

describe 'Books' do
  before :all do
    @search = AmazonProducts::Search.new('Books', 'ruby programming')
    @result = @search.search!.first
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

describe 'Music' do
  before :all do
    @search = AmazonProducts::Search.new('Music', 'Jars of Clay')
    @result = @search.search!.first
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::Music)
  end
  
  it 'should respond to certain methods' do
    %w(asin small_image medium_image large_image title binding label mpn upc original_release_date publisher manufacturer studio number_of_discs artist release_date).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end

describe 'DVD' do
  before :all do
    @search = AmazonProducts::Search.new('DVD', 'Dynamite')
    @result = @search.search!.first
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::DVD)
  end
  
  it 'should respond to certain methods' do
    %w(asin small_image medium_image large_image title actors binding audience_rating
    label publisher creators manufacturer release_date ean list_price
    number_of_items studio package_dimensions upc title aspect_ratio format
    product_type_name brand languages region_code director mpn running_time
    original_release_date theatrical_release_date).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end

describe 'VideoGame' do
  before :all do
    @search = AmazonProducts::Search.new('VideoGames', 'Mario')
    @result = @search.search!.first
  end
  
  it 'should reflect the type of item it is' do
    @result.should be_kind_of(AmazonProducts::VideoGame)
  end
  
  it 'should respond to certain methods' do
    %w(asin small_image medium_image large_image publisher feature product_group
    manufacturer_minimum_age list_price ean package_dimensions manufacturer
    batteries_included mpn item_dimensions amazon_maximum_age upc is_autographed
    release_date genre product_type_name esrb_age_rating package_quantity
    manufacturer_maximum_age label brand platform operating_system amazon_minimum_age
    title model is_memorabilia studio hardware_platform binding).each do |method|
      @result.send(method).should_not be_nil
    end
  end
end