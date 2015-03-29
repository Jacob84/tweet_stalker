require 'rails_helper'
require 'ostruct'

RSpec.describe TwitterListAnalyzer do
  let(:user) { ApplicationUser.new(_id: '5514732f56ef9aadfa000003') }
  let(:url_identifier) { double }
  let(:http_client) { double }
  let(:analyzer) { TwitterListAnalyzer.new(url_identifier, http_client) }

  before do
    Tweet.create(user_id: '5514732f56ef9aadfa000003',
                 twitter_list_id: 1,
                 twitter_tweet_id: 1,
                 urls: 'url1|url2|url3',
                 analyzed: false)

    Tweet.create(user_id: '5514732f56ef9aadfa000004',
                 twitter_list_id: 1,
                 twitter_tweet_id: 1,
                 urls: 'url1',
                 analyzed: false)

    allow(url_identifier).to receive(:should_be_analyzed?).with('url1').and_return(true)
    allow(url_identifier).to receive(:should_be_analyzed?).with('url2').and_return(true)
    allow(url_identifier).to receive(:should_be_analyzed?).with('url3').and_return(false)

    response = OpenStruct.new
    response.body =
        '{"entities_result":
          [{
            "url": "http://bizj.us/1b7rrn",
            "created_at": "2015-02-05 19:53:49.644102",
            "noun_phrases": [["x", 13], ["y", 12]],
            "parsing_time": 0.1029059886932373,
            "title": "Title",
            "download_time": 3.8294730186462402,
            "first_headings": ["Heading"],
            "method_time": 4.007944822311401
          }],
          "result": [["x", 13], ["y", 12]]}'

    allow(http_client).to receive(:get).and_return(response)
  end

  describe 'when processing tweets' do
    before do
      analyzer.process_pending_tweets(user)
    end

    it 'identifies all urls' do
      expect(url_identifier).to have_received(:should_be_analyzed?).exactly(3).times
    end

    it 'only calls nltk-service once' do
      expect(http_client).to have_received(:get).exactly(1).times
    end

    it 'stores noun phrases in tweets' do
      noun_phrases = Tweet.first(
        twitter_tweet_id: 1,
        user_id: '5514732f56ef9aadfa000003').noun_phrases

      expect(noun_phrases[0].value).to eq 'x'
      expect(noun_phrases[0].points).to eq 13
      expect(noun_phrases[1].value).to eq 'y'
      expect(noun_phrases[1].points).to eq 12
    end

    it 'marks tweets as analyzed' do
      tweet = Tweet.first(
        twitter_tweet_id: 1,
        user_id: '5514732f56ef9aadfa000003')

      expect(tweet.analyzed).to eq true
    end
  end

  after :each do
    Tweet.destroy_all
  end
end
