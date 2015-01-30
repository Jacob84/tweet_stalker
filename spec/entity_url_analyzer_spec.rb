require 'entity_url_analyzer'
require 'ostruct'

RSpec.describe EntityUrlAnalyzer, "#urls" do
  context 'with twitter url' do
    before do
      @analyzer = EntityUrlAnalyzer.new
      @url = OpenStruct.new
      @url.url = "http://t.co/ELaJaeLal7"
      @url.extended_url = "https://twitter.com/twitter/timelines/560320"
    end

    it 'should not be analyzed' do
      expect(@analyzer.should_be_analyzed?(@url)).to eq false
    end

    it 'should return the correct type' do
      expect(@analyzer.get_type(@url)).to eq EntityUrlEnumeration::TWITTER
    end
  end

  context 'with other url' do
    before do
      @analyzer = EntityUrlAnalyzer.new
      @url = OpenStruct.new
      @url.url = "http://t.co/ELaJaeLal7"
      @url.extended_url = "https://someurl.com/somelink"
    end

    it 'should be analyzed' do
      expect(@analyzer.should_be_analyzed?(@url)).to eq true
    end

    it 'should return the correct type' do
      expect(@analyzer.get_type(@url)).to eq EntityUrlEnumeration::OTHER
    end
  end

end
