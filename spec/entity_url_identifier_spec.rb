require 'entity_url_identifier'
require 'ostruct'

RSpec.describe EntityUrlIdentifier, "#urls" do

  before do
    @analyzer = EntityUrlIdentifier.new
  end

  context 'with twitter url' do
    before do
      @url = "https://twitter.com/twitter/timelines/560320"
    end

    it 'should not be analyzed' do
      expect(@analyzer.should_be_analyzed?(@url)).to eq false
    end

    it 'should return the correct type' do
      expect(@analyzer.get_type(@url)).to eq EntityUrlEnumeration::TWITTER
    end
  end

  context 'with youtube url' do
    before do
      @url = "https://www.youtube.com/watch?v=XYZ"
    end

    it 'should not be analyzed' do
      expect(@analyzer.should_be_analyzed?(@url)).to eq false
    end

    it 'should return the correct type' do
      expect(@analyzer.get_type(@url)).to eq EntityUrlEnumeration::YOUTUBE
    end
  end

  context 'with other url' do
    before do
      @url = "https://someurl.com/somelink"
    end

    it 'should be analyzed' do
      expect(@analyzer.should_be_analyzed?(@url)).to eq true
    end

    it 'should return the correct type' do
      expect(@analyzer.get_type(@url)).to eq EntityUrlEnumeration::OTHER
    end
  end

end
